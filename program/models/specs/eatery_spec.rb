require('minitest/autorun')
require('minitest/rg')
require_relative('../eatery')


class TestEatery < MiniTest::Test

  def setup
    @eatery1 = Eatery.new({"name" => "Jenna's Juicy Dinner"})
  end


  def test_check_name
    expected = "Jenna's Juicy Dinner"
    actual = @eatery1.name
    assert_equal(expected, actual)
  end


end
