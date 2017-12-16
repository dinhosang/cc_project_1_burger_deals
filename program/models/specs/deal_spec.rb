require('minitest/autorun')
require('minitest/rg')
require_relative('../deal')
require_relative('../burger')


class TestDeal < MiniTest::Test

  def setup
    @deal1 = Deal.new({'type_id' => '1', 'label' => 'Get the Cheapest for FREE!', 'day_id' => '1'})
    @deal2 = Deal.new({'type_id' => '3', 'value' => '£5.00', 'label' => 'Get £5 off your meal!', 'day_id' => '3'})
    @deal3 = Deal.new({'type_id' => '2', 'value' => '1/4', 'label' => 'Enjoy 25% off all day Friday!', 'day_id' => '5'})

    burger1 = Burger.new({'type' => 'beef burger', 'price' => '600'})
    burger2 = Burger.new({'type' => 'cheese burger', 'name' => 'Big Cheese', 'price' => '600'})
    burger3 = Burger.new({'type' => 'burger', 'name' => 'Basic B', 'price' => '823'})
    @burgers = [burger1, burger2, burger3]
  end


  def test_original_total_as_int
    expected = 2023
    actual = Deal.total_int(@burgers)
    assert_equal(expected, actual)
  end


  def test_check_day
    expected = 'Monday'
    actual = @deal1.day
    assert_equal(expected, actual)
  end


  def test_check_label
    expected = 'Get the Cheapest for FREE!'
    actual = @deal1.label
    assert_equal(expected, actual)
  end


  def test_check_type
    expected = 'cheapest'
    actual = @deal1.type
    assert_equal(expected, actual)
  end


  def test_check_value
    expected = '£5.00'
    actual = @deal2.value
    assert_equal(expected, actual)
  end


  def test_calculate_cheapest_free__success
    expected = {original_int: 2023, new_int: 1423}
    actual = @deal1.calculate(@burgers)
    assert_equal(expected, actual)
  end


  def test_calculate_cheapest_free__fail
    burger = Burger.new({'type' => 'beef burger', 'price' => '600'})

    expected = false
    actual = @deal1.calculate([burger])
    assert_equal(expected, actual)
  end


  def test_calculate_monetary_saving
    expected1 = {original_int: 2023, new_int: 1523}
    actual1 = @deal2.calculate(@burgers)
    assert_equal(expected1, actual1)

    @deal2.value = '£4.23'
    expected2 = {original_int: 2023, new_int: 1600}
    actual2 = @deal2.calculate(@burgers)
    assert_equal(expected2, actual2)
  end


  def test_calculate_percentage_saving
    expected1 = {original_int: 2023, new_int: 1517}
    actual1 = @deal3.calculate(@burgers)
    assert_equal(expected1, actual1)

    @deal3.value = '1/3'
    expected2 = {original_int: 2023, new_int: 1349}
    actual2 = @deal3.calculate(@burgers)
    assert_equal(expected2, actual2)
  end


end
