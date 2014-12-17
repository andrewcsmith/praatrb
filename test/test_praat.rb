require 'minitest/autorun'
require 'praat'

class TestPraat < Minitest::Test
  def test_praat_hz_to_midi
    assert_equal 81.0, Praat.hz_to_midi(880.0)
    assert_equal 0.0, Praat.hz_to_midi(nil)
  end
end

