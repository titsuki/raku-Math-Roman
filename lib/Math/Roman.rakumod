unit class Math::Roman:ver<0.0.1>:auth<cpan:TITSUKI> is Real;

my @arabic-table = 1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500, 900, 1000;
my @roman-table = "I", "IV", "V", "IX", "X", "XL", "L", "XC", "C", "CD", "D", "CM", "M";

has $.value;

multi method new(Str $roman) { self.bless(value => to-arabic($roman)) }
multi method new(Int $arabic) { self.bless(value => $arabic) }
method Bridge { $!value }

method Str {
    to-roman($!value)
}

method as-arabic(--> Int) {
    $!value;
}

sub postfix:<R> is export { Math::Roman.new: $^value };

sub to-roman(Int $n where $n >= 0 --> Str) is export {
    if $n <= 0 {
	return "";
    }
    my $pos = binary-search(@arabic-table, $n);
    @roman-table[$pos] ~ to-roman($n - @arabic-table[$pos]);
}

sub to-arabic(Str $r, $pos = 0 --> Int) is export {
    return 0 if $pos == $r.chars;

    my $ret = Nil;
    for 1..@roman-table -> $i {
	if $pos === $r.index(@roman-table[*-$i], $pos) {
	    my $next = to-arabic($r, $pos + @roman-table[*-$i].chars);
	    die if $next === Nil;
	    $ret = @arabic-table[*-$i] + $next;
	    last;
	}
    }
    $ret
}

sub binary-search(@list, $item) {
    my $low  = 0;
    my $high = @list.elems - 1;
    while $low <= $high {
        my $mid = @list[$low] + (@list[$high] - @list[$low]) div 2;
        if $mid > $item {
            $high--;
        } else {
            $low++;
        }
    }
    $low - 1;
}

=begin pod

=head1 NAME

Math::Roman - A roman numerals converter

=head1 SYNOPSIS

=begin code :lang<raku>

use Math::Roman;

10R.say; # X
1996R.say; # MCMXCVI
(1000R + 996R)R.say; # MCMXCVI
(Math::Roman.new: "MCMXCVI").as-arabic.say; # 1996

=end code

=head1 DESCRIPTION

Math::Roman is a roman numerals converter

=head2 CONSTRUCTOR

Defined as:

    multi method new(Str $roman) { self.bless(value => to-arabic($roman)) }
    multi method new(Int $arabic) { self.bless(value => $arabic) }
    method Bridge { $!value }
    sub postfix:<R> is export { Math::Roman.new: $^value };

Creates a C<Math::Roman> instance internally and returns it as an integer or a str corresponding with the context. Postfix C<R> provides a syntactic sugar for converting arabic numerals into roman numerals (e.g., C<10R> returns C<X>).

=head2 METHODS

=head3 as-arabic

Defined as:

    method as-arabic(--> Int)

Returns the instance as an arabic numeral.

=head2 SUBS

=head3 to-roman

Defined as:

    sub to-roman(Int $n where $n >= 0 --> Str) is export

Returns the roman numeral form of the integer C<$n>.

=head3 to-arabic

Defined as:

    sub to-arabic(Str $r, $pos = 0 --> Int) is export

Returns the arabic numeral form of the roman numeral C<$r>.

=head1 AUTHOR

Itsuki Toyota <titsuki@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2020 Itsuki Toyota

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
