package Ham::QSO::Result;
use 5.020;
use strict;
use warnings;
use Storable                      qw(dclone);
use Ham::QSO::_Internal::Data     qw(plain_data);
use Ham::QSO::_Internal::Validate qw(fail named_arguments options);
our $VERSION = '0.001';

sub new {
    my ($class, @pairs) = @_;
    my %args = named_arguments(@pairs);
    options(\%args, 'data');
    fail('QSO_E_ARGUMENT', 'data must be plain acyclic hash data, depth at most 64')
        unless ref($args{data}) eq 'HASH' && plain_data($args{data});
    return bless dclone($args{data}), $class;
}
sub as_hash { my ($self) = @_; return dclone({%{$self}}) }

sub _field {
    my ($self, $key) = @_;
    return ref($self->{$key}) ? dclone($self->{$key}) : $self->{$key};
}
sub text    { my ($self) = @_; return $self->_field('text') }
sub message { my ($self) = @_; return $self->_field('message') }
sub status  { my ($self) = @_; return $self->_field('status') }

sub state {    ## no critic (Subroutines::ProhibitBuiltinHomonyms)
    my ($self) = @_;
    return $self->_field('state');
}
sub revision    { my ($self) = @_; return $self->_field('revision') }
sub complete    { my ($self) = @_; return $self->_field('complete') }
sub terminated  { my ($self) = @_; return $self->_field('terminated') }
sub diagnostics { my ($self) = @_; return $self->_field('diagnostics') }
sub history     { my ($self) = @_; return $self->_field('history') }
sub facts       { my ($self) = @_; return $self->_field('facts') }
sub conformance { my ($self) = @_; return $self->_field('conformance') }
1;

=encoding UTF-8

=head1 NAME

Ham::QSO::Result - independent semantic analysis and session snapshots

=head1 SYNOPSIS

    use strict;
    use warnings;
    use Ham::QSO::Result;
    my $result = Ham::QSO::Result->new(data => {status => 'ambiguous', text => 'IU0?'});
    print $result->status, "\n";

=head1 METHODS

=head2 new

    my $result = Ham::QSO::Result->new(data => {status => 'supported'});

Copies an unblessed, acyclic hash of arrays, hashes and scalars, depth at most
64. Rejects unknown/duplicate options and other payloads with C<QSO_E_ARGUMENT>.
Constructing a Result does not assert that its payload is a valid QSO.

=head2 as_hash

    my $copy = $result->as_hash;

Returns a deep copy suitable for JSON. All reference-valued accessors also copy.

=head2 text

    my $text = $result->text;

Returns original parser input, or undef for a session snapshot.

=head2 message

    my $message = $result->message;

Returns a copied semantic message, or undef if no supported message was found.

=head2 status

    my $status = $result->status;

Parser status: supported, ambiguous, unsupported or violation. Undef on sessions.

=head2 state

    my $state = $result->state;

Returns session state, or undef on parser results.

=head2 revision

    my $revision = $result->revision;

Returns the session revision, starting at zero, or undef on parser results.

=head2 complete

    my $complete = $result->complete;

Returns 0 or 1 for the evidence-based QSO completion predicate, or undef on parsing.

=head2 terminated

    my $terminated = $result->terminated;

Returns 1 only after both parties close or the operator aborts; independent of complete.

=head2 diagnostics

    my $diagnostics = $result->diagnostics;

Returns copied diagnostic records with code, message, rule, severity and event ID
where applicable. Unknown input is not described as a proven regulatory violation.

=head2 history

    my $history = $result->history;

Returns the copied bounded event history. Snapshots are cumulative; replace them.

=head2 facts

    my $facts = $result->facts;

Returns copied identification, report, acknowledgement, closing and turn evidence.

=head2 conformance

    my $conformance = $result->conformance;

Returns checked scope, tri-state status and unassessed obligations. A satisfied
scope is never a general legal certification.

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2026 Giacomo Picchiarelli. Artistic License 2.0.

=cut
