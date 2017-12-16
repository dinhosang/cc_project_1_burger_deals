require_relative('../db/sqlrunner')


class Burger

  attr_reader :id
  attr_accessor :type, :name

  def initialize(options_hash)
    @type = options_hash['type']
    @id = options_hash['id'].to_i if options_hash['id']
    @name = options_hash['name']
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
    return false
  end


  def Burger.find_all
    sql = "SELECT * FROM burgers;"
    burger_hashes = SqlRunner.run(sql)
    return mapper_aid(burger_hashes)
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
    return false
  end


end
