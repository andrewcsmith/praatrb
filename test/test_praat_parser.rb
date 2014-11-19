require 'minitest/autorun'
require 'praat'

class TestPraatParser < Minitest::Test
  def setup
    @parser = Praat::Parser.new
  end

  def test_creates_collection
    input = [[:collection, "frame"]]
    output = @parser.parse input

    assert Object.const_defined? 'Praat::Frames', 'Praat::Frames class not defined'
    assert_kind_of Praat::Frames, output.frames
    assert_kind_of Praat::MetaCollection, output.frames
  end

  def test_creates_object
    input = [[:collection, "frame"], [:object, "frame", 1]]
    output = @parser.parse input

    assert Object.const_defined? 'Praat::Frame', 'Praat::Frame class not defined'
    assert_kind_of Praat::Frames, output.frames
    assert_kind_of Praat::Frame, output.frames.first
    assert_equal output.frames, output.frames.first.parent
  end

  def test_adds_property
    input = [[:collection, "frame"], [:object, "frame", 1], [:property, "time", 0.123]]
    output = @parser.parse input

    assert_equal 0.123, output.frames[0].time
  end

  def test_walks_backward
    input = [[:collection, "frame"], 
              [:indent, 1],
              [:object, "frame", 1], 
                [:indent, 2],
                [:property, "time", 0.123], 
              [:indent, 1],
              [:object, "frame", 2],
                [:indent, 2],
                [:property, "time", 0.456]]

    output = @parser.parse input

    assert_equal 0.123, output.frames[0].time
    assert_equal 0.456, output.frames[1].time
  end

  def test_walks_backward_twice
    input = [[:collection, "frame"], 
              [:indent, 1],
              [:object, "frame", 1], 
                [:indent, 2],
                [:property, "time", 0.123], 
                [:indent, 2],
                [:collection, "candidate"],
                  [:indent, 3],
                  [:object, "candidate", 1],
                    [:indent, 4],
                    [:property, "frequency", 440],
              [:indent, 1],
              [:object, "frame", 2],
                [:indent, 2],
                [:property, "time", 0.456]]

    output = @parser.parse input

    assert_equal 440.0, output.frames[0].candidates[0].frequency
    assert_equal 0.456, output.frames[1].time
  end

  def test_adds_string_property
    input = [[:collection, "frame"], 
              [:object, "frame", 1], 
                [:property, "time", 0.123], 
                [:property, "syllable", "ah"]]

    output = @parser.parse input

    assert_equal 0.123, output.frames[0].time
    assert_equal "ah", output.frames[0].syllable
  end

  def test_snake_cases_attribute
    input = [[:property, "File type", "Collection"]]

    output = @parser.parse input

    assert_respond_to output, :file_type
  end
end
