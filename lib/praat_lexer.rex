module Praat; end

class Praat::Lexer
macros
  INTEGER /\d+/
  FLOAT /\d+\.\d+(?:e-\d\d)?/ # also captures scientific notation
  NUMBER /#{FLOAT}|#{INTEGER}/
  LETTER /[\w\u0250-\u02AF\u00E6\u00F0\u03B8\u014B]/ # includes IPA symbols
  WORD /#{LETTER}+(?: #{LETTER}*)?/ # words may optionally have a space
rules
  # Parse various tokens
  /(#{WORD}) = (#{FLOAT})/    { [:float_property, *matches] }
  /(#{WORD}) = (#{INTEGER})/  { [:integer_property, *matches] }
  /(#{WORD}) = "(#{WORD}|)"/   { [:string_property, *matches] }
  /(#{WORD}) \[\]:/           { [:collection, *matches] }
  /(intervals): size = #{INTEGER}.*/ { [:collection, *matches] }
  /(#{WORD}) \[(#{INTEGER})\]:/ { [:object, *matches] }
  /( {4}+)/                  { [:indent, *matches] }

  # Trailing whitespace and empty lines
  /\s*\n/
  # Ditch the weird tiers? option in TextGrid
  /tiers\?.*/
end

# vim: filetype=ruby

