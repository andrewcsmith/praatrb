require "minitest/autorun"
require "praat_lexer"

class TestPraatLexer < MiniTest::Unit::TestCase
  def setup
    @lexer = Praat::Lexer.new
  end

  def test_parses_candidate
    text = "candidate [1]:\n"
    assert_equal [["candidate", 1]], @lexer.parse(text)
  end

  def test_parses_collection
    text = "frame []:\n"
    assert_equal [["frames"]], @lexer.parse(text)
  end

  def test_parses_float_attribute
    text = "frequency = 67.32"
    assert_equal [["frequency", 67.32]], @lexer.parse(text)
  end

  def test_parses_integer_attribute
    text = "nCandidates = 2"
    assert_equal [["nCandidates", 2]], @lexer.parse(text)
  end

  def test_parses_string_attribute
    text = "fileType = \"Pitch\""
    assert_equal [["fileType", "Pitch"]], @lexer.parse(text)
  end
end
