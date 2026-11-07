package Ham::QSO::_Internal::Validate;
use 5.020;
use strict;
use warnings;
use Exporter 'import';
use Scalar::Util qw(looks_like_number);
use Ham::QSO::Error;
our @EXPORT_OK = qw(fail number integer options named_arguments is_callsign);

sub fail {
    my ($code, $message) = @_;
    return Ham::QSO::Error->throw(code => $code, message => $message);
}

sub named_arguments {
    my (@pairs) = @_;
    fail('QSO_E_ARGUMENT', 'Options must be name/value pairs') if @pairs % 2;
    my %args;
    for (my $i = 0; $i < @pairs; $i += 2) {
        my $name = $pairs[$i];
        fail('QSO_E_ARGUMENT', 'Option names must be defined scalars')
            if !defined($name) || ref($name);
        fail('QSO_E_ARGUMENT', 'Duplicate option name') if exists $args{$name};
        $args{$name} = $pairs[$i + 1];
    }
    return %args;
}

sub number {
    my ($name, $value, $min, $max) = @_;
    fail('QSO_E_ARGUMENT', "$name must be a finite number in [$min, $max]")
        if !defined($value)
        || ref($value)
        || !looks_like_number($value)
        || "$value" =~ /nan|inf/ix
        || $value < $min
        || $value > $max;
    return 0 + $value;
}

sub _integral_representation {
    my ($value) = @_;
    $value =~ s/\A\s+|\s+\z//gx;
    my ($whole, $fraction, $exponent) =
        $value =~ /\A[+-]?([0-9]*)(?:\.([0-9]*))?(?:[eE]([+-]?[0-9]+))?\z/x;
    return 0 unless defined $whole;
    $fraction //= '';
    $exponent //= 0;
    my $digits = $whole . $fraction;
    return 1 unless $digits =~ /[1-9]/x;
    my $places = length $fraction;
    return 1 if $exponent >= $places;
    my $discard = $places - $exponent;
    return 0 if $discard > length $digits;
    return substr($digits, -$discard) !~ /[1-9]/x;
}

sub integer {
    my ($name, $value, $min, $max) = @_;
    number($name, $value, $min, $max);
    fail('QSO_E_ARGUMENT', "$name must be an integer")
        if int($value) != $value
        || ("$value" =~ /[.eE]/x && !_integral_representation("$value"));
    return 0 + $value;
}

sub options {
    my ($args, @names) = @_;
    my %known = map { $_ => 1 } @names;
    for my $key (keys %{$args}) {
        fail('QSO_E_ARGUMENT', "Unknown option: $key") unless $known{$key};
    }
    return;
}

sub is_callsign {
    my ($call) = @_;
    return
           defined($call)
        && !ref($call)
        && length($call) >= 3
        && length($call) <= 32
        && $call =~ /\A[A-Z0-9]+(?:\/[A-Z0-9]+)*\z/x
        && $call =~ /[A-Z]/x
        && $call =~ /[0-9]/x;
}
1;
