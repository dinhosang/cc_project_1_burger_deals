require('minitest/autorun')
require('minitest/rg')
require_relative('../eatory')


class TestEatory < MiniTest::Test

  def setup
    @eatory1 = Eatory.new({"name" => "Jenna's Juicy Dinner"})
  end


  def test_check_name
    expected = "Jenna's Juicy Dinner"
    actual = @eatory1.name
    assert_equal(expected, actual)
  end


end
