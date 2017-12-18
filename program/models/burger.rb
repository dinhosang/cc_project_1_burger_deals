require_relative('../db/sqlrunner')


class Burger

  attr_reader :id
  attr_accessor :type, :name

  def initialize(options_hash)
    @id = options_hash['id'].to_i if options_hash['id']
    @type = options_hash['type']
    @name = options_hash['name'] if options_hash['name']
    @price = options_hash['price'] if options_hash['price']
  end


  def price
    price_pennies = @price
    price_pennies_array = price_pennies.split('')
    price_pennies_array.insert(-3, '.')
    price_pennies_array.unshift('£')
    price_currency = price_pennies_array.join
    return price_currency
  end


  def price_int
    return @price.to_i
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


  def Burger.find_all
    sql = "SELECT * FROM burgers;"
    burger_hashes = SqlRunner.run(sql)
    return mapper_aid(burger_hashes)
  end


  def Burger.find_all_active
    sql = "
    SELECT DISTINCT b.* FROM burgers b INNER JOIN
    deals_eatories_burgers_prices active ON
    active.burger_id = b.id WHERE active.eatory_id
    IS NOT NULL ORDER BY b.type;
    "
    burger_hashes = SqlRunner.run(sql)
    return mapper_aid(burger_hashes)
  end


  def Burger.find_all_inactive
    sql = "
    SELECT b.* FROM burgers b WHERE NOT EXISTS
    (SELECT NULL
    FROM deals_eatories_burgers_prices active
    WHERE active.burger_id = b.id);
    "
    burger_hashes = SqlRunner.run(sql)
    return mapper_aid(burger_hashes)
  end


  def Burger.find_by_deal(deal_id)
    sql = "
    SELECT DISTINCT burgers.id,
    burgers.type, burgers.name,
    deals_eatories_burgers_prices.price
    FROM burgers
    INNER JOIN deals_eatories_burgers_prices ON deals_eatories_burgers_prices.burger_id
    = burgers.id
    WHERE deals_eatories_burgers_prices.deal_id
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


end
