require 'minitest/autorun'
require 'praat'

class TestPraatTextGrid < Minitest::Test
  def setup
    @textgrid = Praat.parse_file 'test/fixtures/word.textgrid'
  end

  def test_parses_segments
    obsessed = @textgrid.items[0].intervalss.select(&:has_text?).first
    assert_equal "obsessed", obsessed.text
    assert_in_delta 0.69148, obsessed.xmin
    assert_in_delta 1.89664, obsessed.xmax
  end

  def test_minmax
    obsessed = @textgrid.items[0].intervalss.select(&:has_text?).first
    expected = [0.69148, 1.89664]
    assert_equal expected.size, obsessed.minmax.size
    obsessed.minmax.zip(expected).each do |m|
      assert_in_delta *m
    end
  end

  def test_extracts_pitch
    pitch = Praat.parse_file 'test/fixtures/obsessed.pitch'
    obsessed = @textgrid.items[0].intervalss.select(&:has_text?).first
    obsessed_pitch = obsessed.extract_pitch pitch
    assert_kind_of Praat::Frames, obsessed_pitch.frames
  end

  def test_extracts_formant
    formant = Praat.parse_file 'test/fixtures/obsessed.formant'
    obsessed = @textgrid.items[0].intervalss.select(&:has_text?).first
    obsessed_formant = obsessed.extract_formant formant
    assert_kind_of Praat::Frames, obsessed_formant.frames
  end
end

