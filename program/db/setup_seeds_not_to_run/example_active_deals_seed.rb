require_relative('example_burgers_seed')
require_relative('example_eatories_seed')
require_relative('example_deals_seed')
require_relative('example_stocked_eatories_seed')

# determined using rand(1..8) and [burgers].sample(int)
@eatory1.add_deal(@deal1, [@burger1, @burger2])
@eatory1.add_deal(@deal8, [@burger4, @burger2])
@eatory1.add_deal(@deal4, [@burger1, @burger2, @burger5])

@eatory2.add_deal(@deal6, [@burger4, @burger8])
@eatory2.add_deal(@deal3, [@burger8, @burger1, @burger6])
@eatory2.add_deal(@deal7, [@burger1, @burger4, @burger5])

@eatory3.add_deal(@deal2, [@burger6, @burger1, @burger3])
@eatory3.add_deal(@deal1, [@burger7, @burger3])
@eatory3.add_deal(@deal3, [@burger6, @burger1, @burger4])

@eatory4.add_deal(@deal1, [@burger2, @burger5])
@eatory4.add_deal(@deal4, [@burger2])
@eatory4.add_deal(@deal6, [@burger1, @burger5])
