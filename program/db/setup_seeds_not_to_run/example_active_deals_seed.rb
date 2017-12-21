require_relative('example_burgers_seed')
require_relative('example_eateries_seed')
require_relative('example_deals_seed')
require_relative('example_stocked_eateries_seed')

# determined using rand(1..8) and [burgers].sample(int)
@eatery1.add_deal({"deal_id" => "#{@deal1.id}", "#{@burger1.id}" => "1", "#{@burger2.id}" => "1"})
@eatery1.add_deal({'deal_id' => "#{@deal8.id}", "#{@burger4.id}" => "1", "#{@burger2.id}" => "1"})
@eatery1.add_deal({'deal_id' => "#{@deal4.id}", "#{@burger1.id}" => "1", "#{@burger2.id}" => "1", "#{@burger5.id}" => "1"})

@eatery2.add_deal({'deal_id' => "#{@deal6.id}", "#{@burger4.id}" => "1", "#{@burger8.id}" => "1"})
@eatery2.add_deal({'deal_id' => "#{@deal3.id}", "#{@burger8.id}" => "1", "#{@burger1.id}" => "1", "#{@burger6.id}" => "1"})
@eatery2.add_deal({'deal_id' => "#{@deal7.id}", "#{@burger1.id}" => "1", "#{@burger4.id}" => "1", "#{@burger5.id}" => "1"})

@eatery3.add_deal({'deal_id' => "#{@deal2.id}", "#{@burger6.id}" => "1", "#{@burger1.id}" => "1", "#{@burger3.id}" => "1"})
@eatery3.add_deal({'deal_id' => "#{@deal1.id}", "#{@burger7.id}" => "1", "#{@burger3.id}" => "1"})
@eatery3.add_deal({'deal_id' => "#{@deal3.id}", "#{@burger6.id}" => "1", "#{@burger1.id}" => "1", "#{@burger4.id}" => "1"})

@eatery4.add_deal({'deal_id' => "#{@deal1.id}", "#{@burger2.id}" => "1", "#{@burger5.id}" => "1"})
@eatery4.add_deal({'deal_id' => "#{@deal4.id}", "#{@burger2.id}" => "1"})
@eatery4.add_deal({'deal_id' => "#{@deal6.id}", "#{@burger1.id}" => "1", "#{@burger5.id}" => "1"})
