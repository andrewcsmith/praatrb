require 'minitest/autorun'
require 'praat'
require 'pry'

class TestPraatFormant < Minitest::Test
  def test_least_squares
    formants = Praat.parse_file 'test/fixtures/o.formant'
    actual = formants.least_squares_formant false
    expected = [10, N[[609.158, -6.542], [1259.045, -0.338], [2628.049, -29.456]]]
    assert_equal expected[0], actual[0]
    assert_equal expected[1].shape, actual[1].shape
    expected[1].zip(actual[1]).each do |ans|
      assert_in_delta ans[0], ans[1]
    end
  end
end

