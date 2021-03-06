module Praat; end

require "praat_lexer.rex.rb"

class Praat::Lexer
  def do_parse 
    output = [] 
    while token = next_token do
      type, *vals = token
      output << send("lex_#{type}", *vals)
    end
    output
  end

  def lex_float_property property, value
    [:property, property.chomp, value.to_f]
  end

  def lex_integer_property property, value
    [:property, property.chomp, value.to_i]
  end

  def lex_string_property property, value
    [:property, property.chomp, value.chomp]
  end

  def lex_collection collection
    [:collection, collection.chomp]
  end

  def lex_object object, index
    [:object, object.chomp, index.to_i]
  end

  def lex_indent spaces
    indents = spaces.length / 4
    [:indent, indents]
  end
end

