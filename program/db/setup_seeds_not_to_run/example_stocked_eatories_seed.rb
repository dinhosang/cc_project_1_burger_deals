require_relative('example_burgers_seed')
require_relative('example_eatories_seed')


@eatory1.add_stock([
  {'burger' => @burger1, 'price' => '350'},
  {'burger' => @burger5, 'price' => '350'},
  {'burger' => @burger7, 'price' => '500'},
  {'burger' => @burger4, 'price' => '450'},
  {'burger' => @burger2, 'price' => '400'}
  ])
@eatory2.add_stock([
  {'burger' => @burger4, 'price' => '450'},
  {'burger' => @burger6, 'price' => '800'},
  {'burger' => @burger5, 'price' => '550'},
  {'burger' => @burger1, 'price' => '450'},
  {'burger' => @burger8, 'price' => '1050'}
  ])

@eatory3.add_stock([
  {'burger' => @burger3, 'price' => '650'},
  {'burger' => @burger1, 'price' => '500'},
  {'burger' => @burger4, 'price' => '600'},
  {'burger' => @burger6, 'price' => '800'},
  {'burger' => @burger7, 'price' => '850'}
  ])

@eatory4.add_stock([
  {'burger' => @burger1, 'price' => '300'},
  {'burger' => @burger2, 'price' => '400'},
  {'burger' => @burger4, 'price' => '350'},
  {'burger' => @burger5, 'price' => '350'}
  ])
