AUOM Algebra (for) Units of Measurement
=======================================

[![Build Status](https://secure.travis-ci.org/mbj/auom.png?branch=master)](http://travis-ci.org/mbj/auom)
[![Dependency Status](https://gemnasium.com/mbj/auom.png)](https://gemnasium.com/mbj/auom)
[![Code Climate](https://codeclimate.com/github/mbj/auom.png)](https://codeclimate.com/github/mbj/auom)

This is another unit system for ruby.
It was created since I was not confident about the existing ones.

Features:

* No unit conversions 
* No core patches (Especially does not require mathn!)
* Dependency free.
* Functional implementation style.
* No magic coercion from number like strings to numbers.
* Will never loose precision (Uses rational as scalar internally)
* Allows namespacing of unit systems via subclass.
* Well tested (100% mutation coverage via [mutant](https://github.com/mbj/mutant))

The default set of predefined units is miminal as this library should be used in an application 
specific subclass. Override: ```AUOM::Unit.units```

Installation
------------

Install the gem `auom` via your preferred method.

Examples
--------

``` ruby
require 'auom'

include AUOM

u = Unit.new(1,  :meter)             # <AUOM::Unit @scalar=1 meter>
u * 100                              # <AUOM::Unit @scalar=100 meter>
u / Unit.new(10, :meter)             # <AUOM::Unit @scalar=0.1>
u / Unit.new(10, [ :meter, :meter ]) # <AUOM::Unit @scaler=0.1 1/meter>
u * Unit.new(10, :meter)             # <AUOM::Unit @scalar=10 meter^2>
u * Unit.new(1,  :euro)              # <AUOM::Unit @scalar=1 euro*meter>
u - Unit.new(1,  :meter)             # <AUOM::Unit @scalar=0 meter>
u + Unit.new(1,  :meter)             # <AUOM::Unit @scalar=2 meter>
u + Unit.new(1,  :euro)              # raises error about incompatible units
```

Credits
-------

Room for your name!

Contributing
-------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with Rakefile or version
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2014 Markus Schirp

See `LICENSE` for details
