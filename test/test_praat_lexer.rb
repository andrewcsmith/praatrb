require 'minitest/autorun'
require 'praat'

class TestPraatLexer < Minitest::Test
  def setup
    @lexer = Praat::Lexer.new
  end

  def test_parses_object
    text = "candidate [1]:\n"
    assert_equal [[:object, "candidate", 1]], @lexer.parse(text)
  end

  def test_parses_collection
    text = "frame []:\n"
    assert_equal [[:collection, "frame"]], @lexer.parse(text)
  end

  def test_parses_float_property
    text = "frequency = 67.32"
    assert_equal [[:property, "frequency", 67.32]], @lexer.parse(text)
  end

  def test_parses_scientific_float
    text = "intensity = 8.3178501338792e-05"
    assert_equal [[:property, "intensity", 8.3178501338792e-05]], @lexer.parse(text)
  end

  def test_parses_integer_property
    text = "nCandidates = 2"
    assert_equal [[:property, "nCandidates", 2]], @lexer.parse(text)
  end

  def test_parses_string_property
    text = "fileType = \"Pitch\""
    assert_equal [[:property, "fileType", "Pitch"]], @lexer.parse(text)
  end

  def test_parses_indents
    text = "        nIndents = 2"
    assert_equal [[:indent, 2], [:property, "nIndents", 2]], @lexer.parse(text)
  end

  def test_parses_collection_with_properties
    text = <<-TXT
frame []: 
    frame [1]:
        intensity = 0 
        nCandidates = 1 
        candidate []: 
            candidate [1]:
                frequency = 0 
                strength = 0.4 
    TXT
    exp = [ [:collection, "frame"],
              [:indent, 1],
              [:object, "frame", 1],
                [:indent, 2],
                [:property, "intensity", 0],
                [:indent, 2],
                [:property, "nCandidates", 1],
                [:indent, 2],
                [:collection, "candidate"],
                  [:indent, 3],
                  [:object, "candidate", 1],
                    [:indent, 4],
                    [:property, "frequency", 0],
                    [:indent, 4],
                    [:property, "strength", 0.4] ]

    assert_equal exp, @lexer.parse(text)
  end
end
