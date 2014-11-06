require 'minitest/autorun'
require 'praat'

class TestPraatParser < Minitest::Test
  def setup
    @parser = Praat::Parser.new
  end

  def test_creates_collection_class
    input = [[:collection, "frame"]]
    @parser.parse input
    assert Object.const_defined? 'Praat::Frame'
  end

  def test_collection_has_methods
    input = [[:collection, "frame"]]
    output = @parser.parse input
    assert_equal [Praat::Frame.new], output
    assert_kind_of Praat::MetaCollection, output.first
  end
end
