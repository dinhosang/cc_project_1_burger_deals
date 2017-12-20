require('pry-byebug')
require_relative('../burger')
require_relative('../eatory')
require_relative('../deal')


burger1 = Burger.new({'type' => 'beef burger'})
burger2 = Burger.new({'type' => 'cheese burger', 'name' => 'Big Cheese'})
burger3 = Burger.new({'type' => 'burger', 'name' => 'Basic B', 'price' => '323'})

eatory1 = Eatory.new({"name" => "Jawsome Burgers"})
eatory2 = Eatory.new({"name" => "Bricks"})
eatory3 = Eatory.new({"name" => "Dinner's #here"})

deal1 = Deal.new({'type_id' => '1', 'label' => 'Get the Cheapest for FREE!', 'day_id' => '1'})
deal2 = Deal.new({'type_id' => '3', 'value' => '£5.00', 'label' => 'Get £5 off your meal!', 'day_id' => '3'})
deal3 = Deal.new({'type_id' => '2', 'value' => '1/4', 'label' => 'Enjoy 25% off all day Friday!', 'day_id' => '5'})


burger1.save
burger2.save
burger3.save
eatory1.save
eatory2.save
eatory3.save
deal1.save
deal2.save
deal3.save

# binding.pry

burger2.name = "Smaller Cheese"
burger3.type = "classy burger"
burger3.name = "Best Burger"
eatory3.name = "Any other name will do"

burger2.update
burger3.update
eatory3.update

eatory1.add_stock({"#{burger1.id}" => '350', "#{burger3.id}" => '500'})

eatory1.add_deal({'deal_id' => deal1.id, "#{burger2.id}" => '1', "#{burger3.id}" => '1'})

eatory1.change_price({"burger" => burger1, "price" => '250'})

burgers_in_eatory1 = eatory1.find_all_burgers

tuesday_deal = Deal.find_all_active_by_day(2)

binding.pry

removing = eatory1.remove_stock_and_return({"#{burger2.id}" => "#{burger2.id}", "#{burger3.id}" => "#{burger3.id}"})

binding.pry

# burger1.delete
eatory2.delete


binding.pry
nil
