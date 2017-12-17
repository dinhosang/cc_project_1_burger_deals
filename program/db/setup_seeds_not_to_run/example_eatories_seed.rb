require_relative('../../models/eatory')


@eatory1 = Eatory.new({"name" => "Jawsome Burgers"})
@eatory2 = Eatory.new({"name" => "Bricks"})
@eatory3 = Eatory.new({"name" => "Dinner's #here"})
@eatory4 = Eatory.new({"name" => "Cool Cids' Cuisine"})

@eatory1.save
@eatory2.save
@eatory3.save
@eatory4.save
