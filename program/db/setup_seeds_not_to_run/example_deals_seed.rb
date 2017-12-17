require_relative('../../models/deal')


@deal1 = Deal.new({'type_id' => '1', 'label' => 'Get the Cheapest for FREE!', 'day_id' => '1'})
@deal2 = Deal.new({'type_id' => '3', 'value' => '£5.00', 'label' => 'Get £5 off your meal!', 'day_id' => '3'})
@deal3 = Deal.new({'type_id' => '2', 'value' => '1/4', 'label' => 'Enjoy 25% off all day Friday!', 'day_id' => '5'})
@deal4 = Deal.new({'type_id' => '2', 'value' => '1/2', 'label' => '50% Sunday', 'day_id' => '7'})
@deal5 = Deal.new({'type_id' => '2', 'value' => '1/3', 'label' => 'One third off of selected burgers', 'day_id' => '1'})
@deal6 = Deal.new({'type_id' => '3', 'value' => '£6.50', 'label' => 'Have £6.50 off your dinner on Tuesday', 'day_id' => '2'})
@deal7 = Deal.new({'type_id' => '3', 'value' => '£3.00', 'label' => '£3 off Thursdays!', 'day_id' => '4'})
@deal8 = Deal.new({'type_id' => '1', 'label' => 'Cheapest Burger is Free!', 'day_id' => '7'})

@deal1.save
@deal2.save
@deal3.save
@deal4.save
@deal5.save
@deal6.save
@deal7.save
@deal8.save
