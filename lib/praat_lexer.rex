module Praat; end

class Praat::Lexer
macros
  INTEGER /\d+/
  FLOAT /\d+\.\d+/
  NUMBER /#{FLOAT}|#{INTEGER}/
  WORD /[A-Za-z]+ ?[A-Za-z]*/
rules
  # Parse various tokens
  /(#{WORD}) = (#{FLOAT})/   { [:float_property, *matches] }
  /(#{WORD}) = (#{INTEGER})/  { [:integer_property, *matches] }
  /(#{WORD}) = "(#{WORD})"/   { [:string_property, *matches] }
  /(#{WORD}) \[\]:/           { [:collection, *matches] }
  /(#{WORD}) \[(#{INTEGER})\]/ { [:object, *matches] }

  # Whitespace 
  /\s+/
  /.*\n/
end

# vim: filetype=ruby

