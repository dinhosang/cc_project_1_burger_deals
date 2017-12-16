require('pry-byebug')
require_relative('../burger')

burger1 = Burger.new({'type' => 'beef burger'})
burger2 = Burger.new({'type' => 'cheese burger', 'name' => 'Big Cheese'})
burger3 = Burger.new({'type' => 'burger', 'name' => 'Basic B', 'price' => '323'})

burger1.save
burger2.save
burger3.save

burger2.name = "Smaller Cheese"
burger3.type = "classy burger"
burger3.name = "Best Burger"

burger2.update
burger3.update

binding.pry
nil
