require_relative('../db/sqlrunner')


class Eatory

  attr_reader :id
  attr_accessor :name

  def initialize(options_hash)
    @id = options_hash['id'].to_i if options_hash['id']
    @name = options_hash['name']
  end


  def add_stock(burgers_prices_hashes_arr)
    for burger_price_hash in burgers_prices_hashes_arr
      burger = burger_price_hash['burger']
      price_int = burger_price_hash['price'].to_i
      sql = "
      INSERT INTO deals_eatories_burgers_prices
      (eatory_id, burger_id, price)
      VALUES ($1, $2, $3)
      "
      values = [@id, burger.id, price_int]
      SqlRunner.run(sql, values)
    end
  end


  def burger_instock?(id)
    sql = "
    SELECT DISTINCT *
    FROM deals_eatories_burgers_prices
    WHERE burger_id = $1 AND eatory_id = $2;"
    values = [id, @id]
    result = SqlRunner.run(sql, values)
    begin
      result[0]
    rescue
      return false
    end
    return true
  end


  def check_burger_price(id)
    if burger_instock?(id)
      sql = "
      SELECT DISTINCT price
      FROM deals_eatories_burgers_prices
      WHERE burger_id = $1 AND eatory_id = $2;
      "
      values = [id, @id]
      price_hash = SqlRunner.run(sql, values)[0]
      return price_hash['price'].to_i
    end
  end


  def add_deal(deal, burgers_array)
    sql = "
    INSERT INTO deals_eatories_burgers_prices
    (deal_id, burger_id, eatory_id, price)
    VALUES ($1, $2, $3, $4);
    "
    for burger in burgers_array
      if burger_instock?(burger.id)
        price = check_burger_price(burger.id)
        values = [deal.id, burger.id, @id, price]
        SqlRunner.run(sql, values)
      end
    end
  end


  def save
    sql = "
          INSERT INTO eatories (name)
          VALUES ($1)
          RETURNING id;
          "
    id_hash = SqlRunner.run(sql, [@name]).first
    @id = id_hash['id'].to_i
  end


  def update
    sql = "
          UPDATE eatories
          SET name = $1
          WHERE id = $2;
          "
    values = [@name, @id]
    SqlRunner.run(sql, values)
  end


  def delete
    sql = "
    DELETE FROM eatories
    WHERE id = $1;
    "
    SqlRunner.run(sql, [@id])
  end


  def Eatory.find(id)
    sql = "
    SELECT * FROM eatories
    WHERE id = $1;
    "
    eatory_hash = SqlRunner.run(sql, [id]).first
    if eatory_hash
      return Eatory.new(eatory_hash)
    end
    return false
  end


  def Eatory.find_all
    sql = "SELECT * FROM eatories;"
    eatory_hashes = SqlRunner.run(sql)
    return mapper_aid(eatory_hashes)
  end


  def self.mapper_aid(eatory_hashes)
    eatories = []
    eatory_hashes.each do |hash|
      eatory = Eatory.new(hash)
      eatories.push(eatory)
    end
    if eatories != []
      return eatories
    end
    return false
  end


end
