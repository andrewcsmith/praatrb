= praat_lex

* http://www.andrewchristophersmith.com/

== DESCRIPTION:

Provides a very malleable Praat file parser

== FEATURES/PROBLEMS:

* Pro: cool idea, doesn't need file specification
* Con: only sort of works, not really tested

The parser parses the basic grammar of Praat files, creating classes whenever
it needs them. It results in a tree of Objects and Collections, with a variety
of attributes that correspond to the grammar it finds in the file. It knows
nothing about Praat. It also only works with long text files.

== SYNOPSIS:

  require 'praat'
  my_collection = Praat.parse_file("my_praat_file.Collection")
  # => #<Praat::Root ... >
  my_collection.items[0]
  # => #<Praat::Item ... >
  # Let's say the first item in the collection was a Pitch object
  # Collection of frames
  my_collection.items[0].frames[0].candidates[0].frequency
  # => 101.2358493290

== REQUIREMENTS:

* oedipux_lex

== INSTALL:

YMMV.

  gem install praatrb

== DEVELOPERS:

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

== LICENSE:

(The MIT License)

Copyright (c) 2014 Andrew Christopher Smith

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
