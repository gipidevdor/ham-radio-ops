package QSOTest;
use 5.020;
use strict;
use warnings;
use Exporter 'import';
use Test::More;
our @EXPORT_OK = qw(throws event completed);

sub throws {
    my ($code, $callback, $label) = @_;
    my $ok    = eval { $callback->(); 1 };
    my $error = $@;
    ok(!$ok && ref($error) && $error->isa('Ham::QSO::Error') && $error->code eq $code, $label)
        or diag('Expected ' . $code . '; got ' . ($error || 'success'));
    return;
}

sub event {
    my ($session, $number, $direction, $text, @extra) = @_;
    if ($direction eq 'tx' && $text =~ /\A(\S+)[ ]DE[ ](\S+)(.*)[ ](KN|K|<AR>|<SK>|CL)\z/x) {
        my ($to, $from, $body, $ending) = ($1, $2, $3, $4);
        $text = "$to DE $from$body $to DE $from $ending";
    }
    return $session->feed(
        id          => "e$number",
        direction   => $direction,
        text        => $text,
        at_ms       => ($number - 1) * 10000,
        duration_ms => 9000,
        $direction eq 'tx'
        ? (identifications => [{start_ms => 0, end_ms => 2000}, {start_ms => 7000, end_ms => 9000}])
        : (),
        @extra
    );
}

sub completed {
    my ($session) = @_;
    event($session, 1, 'tx', 'DL1ABC DE IU0ABC RST 579 KN');
    event($session, 2, 'rx', 'IU0ABC DE DL1ABC R RST 589 KN');
    return event($session, 3, 'tx', 'DL1ABC DE IU0ABC R KN');
}
1;
