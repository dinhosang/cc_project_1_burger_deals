require_relative('../db/sqlrunner')


class Burger

  attr_reader :id
  attr_accessor :type, :name

  def initialize(options_hash)
    @id = options_hash['id'].to_i if options_hash['id']
    @type = options_hash['type']
    @name = options_hash['name'] if options_hash['name']
  end


  def save
    sql = "
          INSERT INTO burgers (type, name)
          VALUES ($1, $2)
          RETURNING id;
          "
    values = [@type, @name]
    id_hash = SqlRunner.run(sql, values).first
    @id = id_hash['id'].to_i
  end


  def update
    sql = "
          UPDATE burgers
          SET (type, name) = ($1, $2)
          WHERE id = $3;
          "
    values = [@type, @name, @id]
    SqlRunner.run(sql, values)
  end


  def delete
    sql = "
    DELETE FROM burgers
    WHERE id = $1;
    "
    SqlRunner.run(sql, [@id])
  end


  def Burger.find(id)
    sql = "
    SELECT * FROM burgers
    WHERE id = $1;
    "
    burger_hash = SqlRunner.run(sql, [id]).first
    if burger_hash
      return Burger.new(burger_hash)
    end
    return nil
  end


  def Burger.find_several(ids)
    burgers = []
    for id in ids
      burgers.push(find(id))
    end
    return burgers
  end


  def Burger.find_all
    sql = "SELECT * FROM burgers;"
    burger_hashes = SqlRunner.run(sql)
    return mapper_aid(burger_hashes)
  end


  def Burger.find_all_types
    sql = "SELECT DISTINCT burgers.type FROM burgers;"
    type_hashes = SqlRunner.run(sql)
    types = []
    type_hashes.each do |hash|
      types.push(hash['type'])
    end
    return types
  end


  def Burger.find_all_names
    sql = "
    SELECT DISTINCT burgers.name FROM burgers
    WHERE NOT burgers.name = '';
    "
    name_hashes = SqlRunner.run(sql)
    names = []
    name_hashes.each do |hash|
      names.push(hash['name'])
    end
    return names
  end


  def Burger.find_all_active
    sql = "
    SELECT DISTINCT b.* FROM burgers b INNER JOIN
    active_deals active ON
    active.burger_id = b.id WHERE active.eatery_id
    IS NOT NULL ORDER BY b.type;
    "
    burger_hashes = SqlRunner.run(sql)
    return mapper_aid(burger_hashes)
  end


  def Burger.find_all_inactive
    sql = "
    SELECT b.* FROM burgers b WHERE NOT EXISTS
    (SELECT NULL
    FROM active_deals active
    WHERE active.burger_id = b.id);
    "
    burger_hashes = SqlRunner.run(sql)
    return mapper_aid(burger_hashes)
  end


  def Burger.find_by_deal(deal_id)
    sql = "
    SELECT DISTINCT burgers.id,
    burgers.type, burgers.name,
    active_deals.price
    FROM burgers
    INNER JOIN active_deals ON active_deals.burger_id
    = burgers.id
    WHERE active_deals.deal_id
    = $1;
    "
    burger_hashes = SqlRunner.run(sql, [deal_id])
    return Burger.mapper_aid(burger_hashes)
  end


  def self.mapper_aid(burger_hashes)
    burgers = []
    burger_hashes.each do |hash|
      burger = Burger.new(hash)
      burgers.push(burger)
    end
    if burgers != []
      return burgers
    end
    return nil
  end

### Methods Created at Start that Never Saw Use

##
# .price is not needed as the eatery is what sets
# and is aware of the price, the burger object is a
# generic one. Function is found in eatery to discover
# price for that burger in that eatery.
#
# Below worked as before the burger class had a price
# property
#
# def price
#   price_pennies = @price
#   price_pennies_array = price_pennies.split('')
#   price_pennies_array.insert(-3, '.')
#   price_pennies_array.unshift('£')
#   price_currency = price_pennies_array.join
#   return price_currency
# end
##



end
