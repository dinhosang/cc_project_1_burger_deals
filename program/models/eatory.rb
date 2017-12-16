require_relative('../db/sqlrunner')


class Eatory

  attr_reader :id
  attr_accessor :name

  def initialize(options_hash)
    @id = options_hash['id'].to_i if options_hash['id']
    @name = options_hash['name']
  end


  def add_stock(burgers_arr)
    for burger in burgers_arr
      sql = "
      INSERT INTO deals_eatories_burgers
      (eatory_id, burger_id)
      VALUES ($1, $2)
      "
      values = [@id, burger.id]
      SqlRunner.run(sql, values)
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
