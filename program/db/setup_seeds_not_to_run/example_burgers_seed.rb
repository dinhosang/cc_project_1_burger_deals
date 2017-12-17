require_relative('../../models/burger')


@burger1 = Burger.new({
  'type' => 'cheese-burger', 'name' => ''
  })
@burger2 = Burger.new({
  'type' => 'bacon-double cheese-burger', 'name' => ''
  })
@burger3 = Burger.new({
  'type' => 'bacon-double cheese-burger', 'name' => 'The BB'
  })
@burger4 = Burger.new({
  'type' => 'veggie burger', 'name' => ''
  })
@burger5 = Burger.new({
  'type' => 'chicken burger', 'name' => ''
  })
@burger6 = Burger.new({
  'type' => 'tofu burger', 'name' => 'Saving Grace'
  })
@burger7 = Burger.new({
  'type' => 'spicy burger', 'name' => ''
  })
@burger8 = Burger.new({
  'type' => 'spicy burger', 'name' => 'The Salsa Slap'
  })

@burger1.save
@burger2.save
@burger3.save
@burger4.save
@burger5.save
@burger6.save
@burger7.save
@burger8.save
