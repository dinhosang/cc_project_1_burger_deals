require_relative('../db/sqlrunner')

class Day

  attr_reader :id, :day

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @day = options['day']
  end


  def Day.find_all
    sql = "SELECT * FROM days ORDER BY days.id ASC;"
    day_hashes = SqlRunner.run(sql)
    return mapper_aid(day_hashes)
  end


  def Day.find(id)
    sql = "
    SELECT * FROM days WHERE id = $1;
    "
    day_hash = SqlRunner.run(sql, [id])[0]
    return Day.new(day_hash)
  end


  def Day.find_by_day(day)
    sql = "
    SELECT * from days WHERE day = $1;
    "
    day_hash = SqlRunner.run(sql, [day])[0]
    return Day.new(day_hash)
  end


  def Day.find_all_active
    sql = "
    SELECT DISTINCT days.id, days.day FROM days INNER JOIN
    deals ON days.id = deals.day_id INNER JOIN
    deals_eatories_burgers_prices ON deals.id =
    deals_eatories_burgers_prices.deal_id
    ORDER BY days.id ASC;
    "
    day_hashes = SqlRunner.run(sql)
    return mapper_aid(day_hashes)
  end


  def Day.find_all_inactive
    sql = "
    SELECT days.id, days.day FROM days WHERE days.id NOT IN (SELECT DISTINCT days.id FROM days INNER JOIN
    deals ON days.id = deals.day_id INNER JOIN
    deals_eatories_burgers_prices ON deals.id =
    deals_eatories_burgers_prices.deal_id) ORDER BY days.id ASC;
    "
    day_hashes = SqlRunner.run(sql)
    return mapper_aid(day_hashes)
  end


  def Day.mapper_aid(day_hashes)
    days = day_hashes.map do |hash|
      Day.new(hash)
    end
    return days
  end

end
