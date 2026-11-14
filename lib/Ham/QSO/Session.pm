package Ham::QSO::Session;
use 5.020;
use strict;
use warnings;
use Storable qw(dclone);
use JSON::PP;
use Ham::QSO::Message;
use Ham::QSO::Profile;
use Ham::QSO::Result;
use Ham::QSO::_Internal::Data     qw(plain_data);
use Ham::QSO::_Internal::Validate qw(fail named_arguments options integer is_callsign);
our $VERSION = '0.001';
my $next_session = 0;

sub new {
    my ($class, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, qw(station peer profile max_events));
    fail('QSO_E_ARGUMENT', 'station must be a full uppercase callsign')
        unless is_callsign($args{station});
    fail('QSO_E_ARGUMENT', 'peer must be a different full uppercase callsign')
        if exists($args{peer})
        && (!is_callsign($args{peer})
        || $args{peer} eq $args{station});
    my $profile = Ham::QSO::Profile->new(name => $args{profile} // 'it-cw');
    my $max     = integer('max_events', $args{max_events} // 5000, 1, 100_000);
    return bless {
        station      => $args{station},
        initial_peer => $args{peer},
        peer         => $args{peer},
        profile      => $profile,
        messages     => Ham::QSO::Message->new(profile => $profile->name),
        max_events   => $max,
        token        => ++$next_session,
        revision     => 0,
        lifecycle    => 'READY',
        history      => [],
        ids          => {},
        diagnostics  => [],
        facts        => {},
        ack_context  => {},
        clock_end    => 0
    }, $class;
}

sub _active {
    my ($self) = @_;
    fail('QSO_E_LIFECYCLE', 'Observation stream has finished; reset or create a session')
        if $self->{lifecycle} eq 'FINISHED';
    return;
}

sub prepare {
    my ($self, @pairs) = @_;
    $self->_active;
    my %args = named_arguments(@pairs);
    fail('QSO_E_SEQUENCE', 'The session has ended')
        if exists $self->{facts}{aborted} || exists $self->{facts}{local_closed};
    fail('QSO_E_ARGUMENT', 'Session supplies the station identity') if exists $args{from};
    $args{to} //= $self->{peer} if ($args{kind} // 'directed') eq 'directed';
    my $text    = $self->{messages}->compose(from => $self->{station}, %args);
    my $message = $self->{messages}->parse($text)->message;
    fail('QSO_E_SEQUENCE', 'Acknowledgement needs an unambiguous preceding opposite over')
        if $message->{ack} && !$self->{ack_context}{rx};
    fail('QSO_E_SEQUENCE', 'Prepared recipient differs from the established peer')
        if defined($self->{peer}) && defined($message->{to}) && $message->{to} ne $self->{peer};
    fail('QSO_E_SEQUENCE', 'After peer closure only a closing message may be prepared')
        if exists($self->{facts}{remote_closed}) && $message->{kind} ne 'close';
    return {
        session  => $self->{token},
        revision => $self->{revision},
        profile  => $self->{profile}->name,
        text     => $text
    };
}

sub transmitted {
    my ($self, $proposal, @pairs) = @_;
    $self->_active;
    fail('QSO_E_ARGUMENT', 'Expected a plain prepared proposal')
        unless ref($proposal) eq 'HASH' && plain_data($proposal);
    options($proposal, qw(session revision profile text));
    integer('session',  $proposal->{session},  1, 2**52);
    integer('revision', $proposal->{revision}, 0, 2**52);
    fail('QSO_E_STALE', 'Proposal belongs to another session or revision')
        if $proposal->{session} != $self->{token}
        || $proposal->{revision} != $self->{revision}
        || !defined($proposal->{profile})
        || ref($proposal->{profile})
        || $proposal->{profile} ne $self->{profile}->name;
    my %args = named_arguments(@pairs);
    options(\%args, qw(id at_ms duration_ms identifications uncertain));
    return $self->feed(%args, direction => 'tx', text => $proposal->{text});
}

sub receive {
    my ($self, $text, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, qw(id at_ms duration_ms uncertain));
    return $self->feed(%args, direction => 'rx', text => $text);
}

sub _diagnostic {
    my ($list, $code, $message, $rule, $severity) = @_;
    push @{$list}, {code => $code, message => $message, rule => $rule, severity => $severity};
    return;
}

sub _apply {
    my ($self, $event, $message, $diagnostics) = @_;
    my $tx   = $event->{direction} eq 'tx';
    my $from = $message->{from};
    if (($tx && $from ne $self->{station}) || (!$tx && $from eq $self->{station})) {
        delete $self->{ack_context}{$event->{direction}};
        _diagnostic($diagnostics, 'QSO_V_SOURCE', 'Message source conflicts with event direction',
            'QSO-R002', 'violation');
        return;
    }
    if (exists($self->{facts}{aborted})
        || (exists($self->{facts}{local_closed}) && exists($self->{facts}{remote_closed})))
    {
        _diagnostic($diagnostics, 'QSO_V_ENDED', 'Evidence received after the session ended',
            'ENG-R001', 'violation');
        return;
    }
    if ($message->{kind} eq 'cq' || $message->{kind} eq 'probe') {
        return $self->_broadcast_event($event, $message, $tx);
    }
    my $other = $tx ? $message->{to} : $from;
    if (   (!$tx && $message->{to} ne $self->{station})
        || (defined($self->{peer}) && $other ne $self->{peer}))
    {
        delete $self->{ack_context}{tx} if $tx;
        _diagnostic($diagnostics, 'QSO_W_OTHER_STATION',
            'Message belongs to another station or peer',
            'QSO-R002', 'unknown');
        return;
    }
    $self->{peer} //= $other;
    return $self->_directed_event($event, $message, $diagnostics);
}

sub _broadcast_event {
    my ($self, $event, $message, $tx) = @_;
    if ($tx) {
        $self->{facts}{calling}  = 1      if $message->{kind} eq 'cq';
        $self->{facts}{turn}     = 'peer' if $message->{ending} eq 'K';
        $self->{ack_context}{tx} = {event_id => $event->{id}, report_event_id => undef};
    }
    elsif (defined($self->{peer}) && $message->{from} eq $self->{peer}) {
        delete $self->{ack_context}{rx};
    }
    return;
}

sub _directed_event {
    my ($self, $event, $message, $diagnostics) = @_;
    my $tx    = $event->{direction} eq 'tx';
    my $facts = $self->{facts};
    if (exists $facts->{$tx ? 'local_closed' : 'remote_closed'}) {
        _diagnostic($diagnostics, 'QSO_V_CLOSED_PARTY', 'Sender has already closed this contact',
            'QSO-R003', 'violation');
        return;
    }
    $facts->{$tx ? 'identified_local' : 'identified_remote'} = $event->{id};
    $self->_report_evidence($event, $message, $diagnostics, $tx);
    $facts->{request} = $message->{request} if exists $message->{request};
    $facts->{turn}    = $tx ? 'peer' : 'local'
        if $message->{ending} eq 'K' || $message->{ending} eq 'KN' || $message->{ending} eq '<KN>';
    $facts->{turn} = $tx ? 'local' : 'peer'
        if $message->{ending} eq '<AR>'
        || ($message->{request} // '') eq 'QRX';
    if ($message->{kind} eq 'close') {
        $facts->{$tx ? 'local_closed' : 'remote_closed'} = $event->{id};
        $facts->{station_closed} = $event->{id} if $tx && $message->{ending} eq 'CL';
    }
    return;
}

sub _acknowledge {
    my ($self, $message, $diagnostics, $tx) = @_;
    return unless $message->{ack};
    my $context = $self->{ack_context}{$tx ? 'rx' : 'tx'};
    if (!$context) {
        _diagnostic($diagnostics, 'QSO_W_ACK_CONTEXT',
            'Acknowledgement has no unambiguous preceding opposite over',
            'QSO-R001', 'unknown');
        return;
    }
    my $facts = $self->{facts};
    $facts->{$tx ? 'sent_message_ack_for' : 'received_message_ack_for'} = $context->{event_id};
    $facts->{$tx ? 'sent_ack_for'         : 'received_ack_for'} = $context->{report_event_id}
        if defined $context->{report_event_id};
    return;
}

sub _report_evidence {
    my ($self, $event, $message, $diagnostics, $tx) = @_;
    my $facts = $self->{facts};
    $self->_acknowledge($message, $diagnostics, $tx);
    if (exists $message->{report}) {
        my $key = $tx ? 'sent_report'      : 'received_report';
        my $ack = $tx ? 'received_ack_for' : 'sent_ack_for';
        if (!$facts->{$key} || $facts->{$key}{value} ne $message->{report}) {
            delete $facts->{$ack};
            $facts->{$key} = {value => $message->{report}, event_id => $event->{id}};
        }
    }
    my $report_key = $tx ? 'sent_report' : 'received_report';
    $self->{ack_context}{$event->{direction}} = {
        event_id        => $event->{id},
        report_event_id => exists($message->{report}) ? $facts->{$report_key}{event_id} : undef
    };
    return;
}

sub _event_input {
    my ($self, @pairs) = @_;
    $self->_active;
    my %event = named_arguments(@pairs);
    options(\%event, qw(id direction text at_ms duration_ms identifications uncertain));
    fail('QSO_E_ARGUMENT', 'id must be 1..128 ASCII letters, digits, underscores or hyphens')
        if !defined($event{id}) || ref($event{id}) || $event{id} !~ /\A[A-Za-z0-9_-]{1,128}\z/x;
    fail('QSO_E_ARGUMENT', 'direction must be tx or rx')
        if !defined($event{direction})
        || ref($event{direction})
        || $event{direction} !~ /\A(?:tx|rx)\z/x;
    $event{at_ms}       = integer('at_ms',       $event{at_ms},       0, 2**52);
    $event{duration_ms} = integer('duration_ms', $event{duration_ms}, 1, 2**52 - $event{at_ms});
    $event{uncertain} =
        exists($event{uncertain}) ? integer('uncertain', $event{uncertain}, 0, 1) : 0;
    my $analysis = $self->{messages}->parse($event{text});
    my $identification;

    if ($event{direction} eq 'tx') {
        $identification = $self->{profile}->check_identification(
            duration_ms => $event{duration_ms},
            exists($event{identifications}) ? (identifications => $event{identifications}) : ()
        );
    }
    else {
        fail('QSO_E_ARGUMENT', 'Remote identification timing is outside this station profile')
            if exists $event{identifications};
    }
    return (\%event, $analysis, $identification);
}

sub _identification_consistency {
    my ($self, $event, $diagnostics) = @_;
    return unless $event->{direction} eq 'tx' && exists $event->{identifications};
    my $call     = $self->{station};
    my $text     = uc $event->{text};
    my $mentions = () = $text =~ /(?<![A-Z0-9\/])\Q$call\E(?![A-Z0-9\/])/gx;
    if (@{$event->{identifications}} > $mentions) {
        _diagnostic(
            $diagnostics,
            'QSO_V_IDENTIFICATION_EVIDENCE',
            'Claimed identification spans exceed complete station identities in the transcript',
            'ENG-R001', 'violation'
        );
    }
    return;
}

sub feed {
    my ($self, @pairs) = @_;
    my ($event, $analysis, $identification) = $self->_event_input(@pairs);
    if (my $previous = $self->{ids}{$event->{id}}) {
        my $json = JSON::PP->new->canonical;
        fail('QSO_E_DUPLICATE', 'An event ID was reused for different evidence')
            if $json->encode($previous->{event}) ne $json->encode($event);
        return $self->snapshot;
    }
    fail('QSO_E_RESOURCE', 'Session event limit exceeded')
        if @{$self->{history}} >= $self->{max_events};
    fail('QSO_E_SEQUENCE', 'Events must be chronological and nonoverlapping')
        if $event->{at_ms} < $self->{clock_end};

    # All validation precedes mutation. Observed violations remain in the record.
    my @diagnostics = @{$analysis->diagnostics};
    $self->_identification_consistency($event, \@diagnostics);
    delete $self->{ack_context}{$event->{direction}}
        if $analysis->status ne 'supported' || $event->{uncertain};
    if ($event->{uncertain}) {
        _diagnostic(\@diagnostics, 'QSO_W_UNCERTAIN',
            'Reception or transmission is uncertain; facts withheld',
            'ENG-R001', 'unknown');
    }
    if (   $identification
        && $identification->{status} ne 'not_assessed'
        && $identification->{status} ne 'satisfied')
    {
        _diagnostic(
            \@diagnostics,
            'QSO_' . ($identification->{status} eq 'violated' ? 'V' : 'W') . '_IDENTIFICATION',
            'Italian identification evidence is ' . $identification->{status},
            'IT-R001',
            $identification->{status} eq 'violated' ? 'violation' : 'unknown'
        );
    }
    $self->_apply($event, $analysis->message, \@diagnostics)
        if $analysis->status eq 'supported' && !$event->{uncertain};
    for my $diagnostic (@diagnostics) { $diagnostic->{event_id} = $event->{id} }
    push @{$self->{diagnostics}}, @diagnostics;
    my $observation = {
        event          => dclone($event),
        analysis       => $analysis->as_hash,
        identification => $identification,
        diagnostics    => dclone(\@diagnostics)
    };
    push @{$self->{history}}, $observation;
    $self->{ids}{$event->{id}} = $observation;
    $self->{clock_end} = $event->{at_ms} + $event->{duration_ms};
    $self->{revision}++;
    $self->{lifecycle} = 'ACTIVE';
    return $self->snapshot;
}

sub select_peer {
    my ($self, @pairs) = @_;
    $self->_active;
    my %args = named_arguments(@pairs);
    options(\%args, qw(callsign evidence_id));
    fail('QSO_E_ARGUMENT', 'Expected a full callsign and an observed evidence ID')
        if !is_callsign($args{callsign})
        || !defined($args{evidence_id})
        || ref($args{evidence_id});
    my $evidence = $self->{ids}{$args{evidence_id}};
    my $message  = $evidence ? $evidence->{analysis}{message} : undef;
    fail('QSO_E_SEQUENCE',
        'Peer selection requires certain, fully parsed RX evidence addressed to this station')
        if !$message
        || $evidence->{event}{direction} ne 'rx'
        || $evidence->{event}{uncertain}
        || ($message->{to} // '') ne $self->{station}
        || $message->{from} ne $args{callsign};
    fail('QSO_E_SEQUENCE', 'Cannot change peer after closure or abort')
        if exists($self->{facts}{local_closed})
        || exists($self->{facts}{remote_closed})
        || exists($self->{facts}{aborted});
    fail('QSO_E_RESOURCE', 'Session event limit exceeded')
        if @{$self->{history}} >= $self->{max_events};
    $self->{peer}        = $args{callsign};
    $self->{facts}       = {identified_remote => $args{evidence_id}};
    $self->{ack_context} = {};
    push @{$self->{history}},
        {
        operator    => 'select_peer',
        callsign    => $args{callsign},
        evidence_id => $args{evidence_id}
        };
    $self->{revision}++;
    return $self->snapshot;
}

sub abort {
    my ($self, @pairs) = @_;
    $self->_active;
    my %args = named_arguments(@pairs);
    options(\%args, 'reason');
    fail('QSO_E_ARGUMENT', 'reason must be a nonempty scalar of at most 1024 characters')
        if !defined($args{reason})
        || ref($args{reason})
        || !length($args{reason})
        || length($args{reason}) > 1024;
    return $self->snapshot if exists $self->{facts}{aborted};
    fail('QSO_E_RESOURCE', 'Session event limit exceeded')
        if @{$self->{history}} >= $self->{max_events};
    $self->{facts}{aborted} = $args{reason};
    push @{$self->{history}}, {operator => 'abort', reason => $args{reason}};
    $self->{revision}++;
    return $self->snapshot;
}

sub _completion {
    my ($facts) = @_;
    my $complete =
           exists($facts->{identified_local})
        && exists($facts->{identified_remote})
        && $facts->{sent_report}
        && $facts->{received_report}
        && ($facts->{sent_ack_for}     // '') eq ($facts->{received_report}{event_id} // '-')
        && ($facts->{received_ack_for} // '') eq ($facts->{sent_report}{event_id} // '-') ? 1 : 0;
    my $terminated = exists($facts->{aborted})
        || (exists($facts->{local_closed}) && exists($facts->{remote_closed})) ? 1 : 0;
    return ($complete, $terminated);
}

sub _state {
    my ($facts, $complete, $terminated) = @_;
    my $state =
          exists($facts->{aborted})                                                   ? 'ABORTED'
        : $terminated                                                                 ? 'TERMINATED'
        : (exists($facts->{local_closed}) || exists($facts->{remote_closed}))         ? 'CLOSING'
        : $complete                                                                   ? 'COMPLETE'
        : ($facts->{sent_report} || $facts->{received_report})                        ? 'EXCHANGING'
        : (exists($facts->{identified_local}) || exists($facts->{identified_remote})) ? 'CONTACT'
        : $facts->{calling}                                                           ? 'CALLING'
        :                                                                               'READY';
    return $state;
}

sub snapshot {
    my ($self) = @_;
    my $facts = $self->{facts};
    my ($complete, $terminated) = _completion($facts);
    my $state      = _state($facts, $complete, $terminated);
    my $violations = grep { $_->{severity} eq 'violation' } @{$self->{diagnostics}};
    my $unknowns   = grep { $_->{severity} eq 'unknown' } @{$self->{diagnostics}};
    return Ham::QSO::Result->new(
        data => {
            profile     => $self->{profile}->as_hash,
            station     => $self->{station},
            peer        => $self->{peer},
            revision    => $self->{revision},
            lifecycle   => $self->{lifecycle},
            state       => $state,
            complete    => $complete,
            terminated  => $terminated,
            facts       => $facts,
            history     => $self->{history},
            diagnostics => $self->{diagnostics},
            conformance => {
                scope => 'Supported semantic messages and supplied station identification evidence',
                status => $violations ? 'violated'
                : ($unknowns || !@{$self->{history}}) ? 'indeterminate'
                : 'satisfied',
                legal_status => 'not_assessed',
                unassessed   => [
                    'Station and counterpart authorisations and callsign assignments',
                    'RF frequency, occupied bandwidth, power, band plan and interference',
                    'Actual on-air transmission and truth of caller-supplied evidence',
                    'Unattended operation, emergency traffic, contests and award-specific rules',
                    'All legal obligations outside the identified checks'
                ]
            }
        }
    );
}

sub finish {
    my ($self) = @_;
    $self->{lifecycle} = 'FINISHED';
    return $self->snapshot;
}

sub reset {    ## no critic (Subroutines::ProhibitBuiltinHomonyms)
    my ($self) = @_;
    my $fresh = __PACKAGE__->new(
        station    => $self->{station},
        profile    => $self->{profile}->name,
        max_events => $self->{max_events},
        defined($self->{initial_peer}) ? (peer => $self->{initial_peer}) : ()
    );
    %{$self} = %{$fresh};
    return $self->snapshot;
}
1;

=encoding UTF-8

=head1 NAME

Ham::QSO::Session - transactional evidence and ordinary two-station QSO lifecycle

=head1 SYNOPSIS

    use strict;
    use warnings;
    use Ham::QSO::Session;
    my $session = Ham::QSO::Session->new(station => 'IU0ABC', profile => 'it-cw');
    my $proposal = $session->prepare(kind => 'cq');
    print $proposal->{text}, "\n";
    # Call only after the application observes actual transmission:
    my $snapshot = $session->transmitted($proposal, id => 'tx1', at_ms => 0,
        duration_ms => 12000, identifications => [
            {start_ms => 0, end_ms => 3000}, {start_ms => 9000, end_ms => 12000}]);
    print $snapshot->state, "\n";

=head1 METHODS

=head2 new

    my $session = Ham::QSO::Session->new(station => 'IU0ABC', peer => 'DL1ABC',
        profile => 'it-cw', max_events => 5000);

Station is required; peer is optional. Both must be complete uppercase lexical
callsigns and differ. max_events is 1..100000, default 5000. Profile defaults
to it-cw. Starts at READY, revision zero. No clock, device or network is consulted.

=head2 prepare

    my $proposal = $session->prepare(to => 'DL1ABC', report => '579');

Uses Message compose options except from, which the session supplies. Defaults
to the selected peer. Returns a plain proposal with text, profile, session token
and revision. Does not mutate anything. Rejects acknowledgement without an unambiguous preceding opposite over,
peer mismatch and local closure/abort with QSO_E_SEQUENCE. After remote
closure only a closing message can be prepared. Proposals are application data,
not an authenticity or security boundary.

=head2 transmitted

    my $snapshot = $session->transmitted($proposal, id => 'tx1', at_ms => 0,
        duration_ms => 10000);

Records actual TX using feed. A proposal for another session or revision throws
QSO_E_STALE. Requires caller evidence that transmission actually occurred;
rendering or writing audio is not transmission. Italian timing evidence is optional
input, but absence makes the checked scope indeterminate. Observed violations
are recorded with diagnostics rather than discarded.

=head2 receive

    my $snapshot = $session->receive('IU0ABC DE DL1ABC RST 579 KN',
        id => 'rx1', at_ms => 10000, duration_ms => 10000, uncertain => 0);

Convenience RX feed. uncertain defaults to zero; set to 1 for unreliable reception.

=head2 feed

    my $snapshot = $session->feed(direction => 'rx', text => 'IU0? DE DL1ABC KN',
        id => 'rx1', at_ms => 0, duration_ms => 1000);

Events require id (1..128 ASCII alphanumeric, underscore or hyphen), direction
(tx/rx), text, integer at_ms >= 0 and duration_ms >= 1. End must not exceed 2**52.
Times share a caller-chosen millisecond epoch, are monotonic and cannot overlap.
Optional uncertain is 0/1. TX alone accepts Profile identification spans.
Malformed arguments, overlap, conflicting IDs and resource overflow throw before
mutation. Identical replay of an event ID is idempotent. Unknown, partial and
uncertain messages remain in history but prove no semantic facts. Messages for
another station cannot alter the selected peer or its reports. Reports belong to
the addressed recipient. Explicit R/RR acknowledges the immediately preceding relevant opposite over;
it proves report reception only if that over carried the report. An unknown or
uncertain over blocks that association. Generic message acknowledgement is tracked
separately; corrected values invalidate dependent acknowledgement evidence. Identical
report repetitions preserve it. Neither 73 nor message/contact endings imply R.

=head2 select_peer

    my $snapshot = $session->select_peer(callsign => 'DL1ABC', evidence_id => 'rx1');

Explicit operator correction/selection. Requires certain supported RX with that
full sender, addressed to this station. Clears all report/ack/local identification
facts and records the selection; old proof cannot be transferred to another peer.
Throws QSO_E_SEQUENCE on missing evidence or after closure/abort.

=head2 abort

    my $snapshot = $session->abort(reason => 'Lost propagation');

Records operator termination without inventing completion. reason is a nonempty
scalar of at most 1024 characters. Repeating abort is idempotent.

=head2 snapshot

    my $snapshot = $session->snapshot;

Returns an independent cumulative Result. complete requires mutual directed
identification, both reports and explicit acknowledgements of each current report.
Closing and completion are orthogonal. Both closings or abort make terminated true.
States: READY, CALLING, CONTACT, EXCHANGING, COMPLETE, CLOSING, TERMINATED, ABORTED.
Conformance is satisfied/indeterminate/violated only in its explicit checked scope;
legal_status remains not_assessed. See docs/standards.md for boundaries.

=head2 finish

    my $snapshot = $session->finish;

Ends observation, idempotently. Does not assert QSO closure or completion. Further
mutating operations throw QSO_E_LIFECYCLE until reset. Snapshot remains available.

=head2 reset

    my $snapshot = $session->reset;

Clears history and facts, retains configuration, invalidates earlier proposals.

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2026 Giacomo Picchiarelli. Artistic License 2.0.

=cut
