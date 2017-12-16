require('minitest/autorun')
require('minitest/rg')
require_relative('../burger')


class TestBurger < MiniTest::Test

  def setup
    @burger1 = Burger.new({"type" => "cheese burger", 'id' => "1", 'price' => '350', 'name' => 'The Greatest'})
  end


  def test_check_type
    expected = "cheese burger"
    actual = @burger1.type
    assert_equal(expected, actual)
  end


  def test_check_id
    expected = 1
    actual = @burger1.id
    assert_equal(expected, actual)
  end


  def test_check_price
    expected = "£3.50"
    actual = @burger1.price
    assert_equal(expected, actual)
  end


  def test_check_name
    expected = "The Greatest"
    actual = @burger1.name
    assert_equal(expected, actual)
  end


  def test_change_name
    @burger1.name = "Less than Greatest"
    expected = "Less than Greatest"
    actual = @burger1.name
    assert_equal(expected, actual)
  end


  def test_change_type
    @burger1.type = "bacon double"
    expected = "bacon double"
    actual = @burger1.type
    assert_equal(expected, actual)
  end


end
