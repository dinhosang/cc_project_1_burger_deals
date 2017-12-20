require_relative('example_burgers_seed')
require_relative('example_eatories_seed')


@eatory1.add_stock(
  {"#{@burger1.id}" => '350',"#{@burger5.id}" => '350' ,"#{@burger7.id}" => '500', "#{@burger4.id}" => '450', "#{@burger2.id}" => '400'}
)
@eatory2.add_stock(
  {"#{@burger4.id}" => '450', "#{@burger6.id}" => '800', "#{@burger5.id}" => '550', "#{@burger1.id}" => '450', "#{@burger8.id}" => '1050'}
)

@eatory3.add_stock(
  {"#{@burger3.id}" => '650', "#{@burger1.id}" => '500', "#{@burger4.id}" => '600', "#{@burger6.id}" => '800', "#{@burger7.id}" => '850'}
)

@eatory4.add_stock(
  {"#{@burger1.id}" => '300', "#{@burger2.id}" => '400', "#{@burger4.id}" => '350', "#{@burger5.id}" => '350'}
)
