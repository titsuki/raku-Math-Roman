[![Actions Status](https://github.com/titsuki/raku-Math-Roman/workflows/test/badge.svg)](https://github.com/titsuki/raku-Math-Roman/actions)

NAME
====

Math::Roman - A roman numerals converter

SYNOPSIS
========

```raku
use Math::Roman;

10R.say; # X
1996R.say; # MCMXCVI
(1000R + 996R)R.say; # MCMXCVI
(Math::Roman.new: "MCMXCVI").as-arabic.say; # 1996
```

DESCRIPTION
===========

Math::Roman is a roman numerals converter

CONSTRUCTOR
-----------

Defined as:

    multi method new(Str $roman) { self.bless(value => to-arabic($roman)) }
    multi method new(Int $arabic) { self.bless(value => $arabic) }
    method Bridge { $!value }
    sub postfix:<R> is export { Math::Roman.new: $^value };

Creates a `Math::Roman` instance internally and returns it as an integer or a str corresponding with the context. Postfix `R` provides a syntactic sugar for converting arabic numerals into roman numerals (e.g., `10R` returns `X`).

METHODS
-------

### as-arabic

Defined as:

    method as-arabic(--> Int)

Returns the instance as an arabic numeral.

SUBS
----

### to-roman

Defined as:

    sub to-roman(Int $n where $n >= 0 --> Str) ix export

Returns the roman numeral form of the integer `$n`.

### to-arabic

Defined as:

    sub to-arabic(Str $r, $pos = 0 --> Int) is export

Returns the arabic numeral form of the roman numeral `$r`.

AUTHOR
======

Itsuki Toyota <titsuki@cpan.org>

COPYRIGHT AND LICENSE
=====================

Copyright 2020 Itsuki Toyota

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

