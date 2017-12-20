require_relative('example_burgers_seed')
require_relative('example_eatories_seed')
require_relative('example_deals_seed')
require_relative('example_stocked_eatories_seed')

# determined using rand(1..8) and [burgers].sample(int)
@eatory1.add_deal({"deal_id" => "#{@deal1.id}", "#{@burger1.id}" => "1", "#{@burger2.id}" => "1"})
@eatory1.add_deal({'deal_id' => "#{@deal8.id}", "#{@burger4.id}" => "1", "#{@burger2.id}" => "1"})
@eatory1.add_deal({'deal_id' => "#{@deal4.id}", "#{@burger1.id}" => "1", "#{@burger2.id}" => "1", "#{@burger5.id}" => "1"})

@eatory2.add_deal({'deal_id' => "#{@deal6.id}", "#{@burger4.id}" => "1", "#{@burger8.id}" => "1"})
@eatory2.add_deal({'deal_id' => "#{@deal3.id}", "#{@burger8.id}" => "1", "#{@burger1.id}" => "1", "#{@burger6.id}" => "1"})
@eatory2.add_deal({'deal_id' => "#{@deal7.id}", "#{@burger1.id}" => "1", "#{@burger4.id}" => "1", "#{@burger5.id}" => "1"})

@eatory3.add_deal({'deal_id' => "#{@deal2.id}", "#{@burger6.id}" => "1", "#{@burger1.id}" => "1", "#{@burger3.id}" => "1"})
@eatory3.add_deal({'deal_id' => "#{@deal1.id}", "#{@burger7.id}" => "1", "#{@burger3.id}" => "1"})
@eatory3.add_deal({'deal_id' => "#{@deal3.id}", "#{@burger6.id}" => "1", "#{@burger1.id}" => "1", "#{@burger4.id}" => "1"})

@eatory4.add_deal({'deal_id' => "#{@deal1.id}", "#{@burger2.id}" => "1", "#{@burger5.id}" => "1"})
@eatory4.add_deal({'deal_id' => "#{@deal4.id}", "#{@burger2.id}" => "1"})
@eatory4.add_deal({'deal_id' => "#{@deal6.id}", "#{@burger1.id}" => "1", "#{@burger5.id}" => "1"})
