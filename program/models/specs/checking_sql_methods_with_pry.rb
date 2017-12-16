require('pry-byebug')
require_relative('../burger')
require_relative('../eatory')

burger1 = Burger.new({'type' => 'beef burger'})
burger2 = Burger.new({'type' => 'cheese burger', 'name' => 'Big Cheese'})
burger3 = Burger.new({'type' => 'burger', 'name' => 'Basic B', 'price' => '323'})

eatory1 = Eatory.new({"name" => "Jawsome Burgers"})
eatory2 = Eatory.new({"name" => "Bricks"})
eatory3 = Eatory.new({"name" => "Dinner's #here"})


burger1.save
burger2.save
burger3.save
eatory1.save
eatory2.save
eatory3.save

# binding.pry

burger2.name = "Smaller Cheese"
burger3.type = "classy burger"
burger3.name = "Best Burger"
eatory3.name = "Any other name will do"

burger2.update
burger3.update
eatory3.update

eatory1.add_stock([burger1, burger3])

binding.pry

burger1.delete
eatory2.delete


binding.pry
nil
