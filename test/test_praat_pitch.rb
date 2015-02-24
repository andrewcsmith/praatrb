require 'minitest/autorun'
require 'praat'

class TestPraatPitch < Minitest::Test
  def setup
    @pitch = Praat.parse_file 'test/fixtures/tajm.Pitch'
  end

  def test_parse_file
    assert_equal 600, @pitch.ceiling
  end

  def test_find_dominant_pitch
    output = Praat.find_dominant_pitch @pitch
    assert_respond_to output.frames[0], :freq
    assert_nil output.frames[0].freq
    assert_in_delta 180.141, output.frames[1].freq
  end
end

