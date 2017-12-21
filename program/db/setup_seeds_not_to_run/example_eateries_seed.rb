require_relative('../../models/eatery')


@eatery1 = Eatery.new({"name" => "Jawsome Burgers"})
@eatery2 = Eatery.new({"name" => "Bricks"})
@eatery3 = Eatery.new({"name" => "Dinner's #here"})
@eatery4 = Eatery.new({"name" => "Cool Cids' Cuisine"})

@eatery1.save
@eatery2.save
@eatery3.save
@eatery4.save
