require('pry-byebug')
require_relative('eatory')
require_relative('../db/sqlrunner')


class Deal

  attr_reader :id
  attr_accessor :label, :type, :value, :type_id, :day_id

  def initialize(options_hash)
    @id = options_hash['id'].to_i if options_hash['id']
    @label = options_hash['label']
    @day_id = options_hash['day_id'].to_i
    # shouldn't need both if statements, should only
    # require id or name, will rework once sure which
    # I will use more often - probably id
    if options_hash['type_id']
      @type_id = options_hash['type_id'].to_i
    else
      @type_id = Deal.find_type_id(options_hash['type'])
    end
    if options_hash['type']
      @type = options_hash['type']
    else
      @type = Deal.find_type(@type_id)
    end
    if @type != 'cheapest'
      @value = options_hash['value'] if options_hash['value']
    end
  end


  def value_string
    return "Cheapest item is free" if @type_id == 1
    return "#{@value} off order when conditions are met"
  end


  def update
    sql = "
    UPDATE deals SET (label, day_id, type_id, value) =
    ($1, $2, $3, $4) WHERE id = $5;
    "
    values = [@label, @day_id, @type_id, @value, @id]
    SqlRunner.run(sql, values)
  end


  def delete
    sql = "DELETE FROM deals WHERE id = $1;"
    SqlRunner.run(sql, [@id])
  end


  def save
    sql = "
          INSERT INTO deals (type_id, label, value, day_id)
          VALUES ($1, $2, $3, $4)
          RETURNING id;
          "
    values = [@type_id, @label, @value, @day_id]
    id_hash = SqlRunner.run(sql, values).first
    @id = id_hash['id'].to_i
  end


  def day
    sql = "SELECT * FROM days WHERE id = $1"
    day_hash = SqlRunner.run(sql, [@day_id])[0]
    return day_hash['day']
  end


  def calculate(burgers_arr)
    if @type == "cheapest"
      return false if burgers_arr.length < 2
      calculation = calculate_cheapest_free(burgers_arr)
    elsif type == "fraction"
      calculation = calculate_fraction_saving(burgers_arr)
    elsif type == "monetary"
      calculation = calculate_monetary_saving(burgers_arr)
    end
    saving_amount_int = calculation[:original_int] - calculation[:new_int]
    calculation[:saving_int] = saving_amount_int
    return calculation
  end


  def calculate_cheapest_free(burgers)
    original_total_int = Deal.total_int(burgers)
    cheapest_burger = nil
    for burger in burgers
      if cheapest_burger != nil
        if cheapest_burger.price_int > burger.price_int
          cheapest_burger = burger
        end
      else
        cheapest_burger = burger
      end
    end
    burgers.delete(cheapest_burger)
    after_saving_total_int = Deal.total_int(burgers)
    calculation = {original_int: original_total_int, new_int: after_saving_total_int}
    return calculation
  end


  def calculate_fraction_saving(burgers)
    original = Deal.total_int(burgers)

    fraction_array = self.value.split('/')
    numerator = fraction_array[0].to_i
    denominator = fraction_array[1].to_f

    percent_mult = 1 - (numerator / denominator)
    saving_unrounded = original * percent_mult

    after_saving_total_int = saving_unrounded.round(0)

    calculation = {original_int: original, new_int: after_saving_total_int}
    return calculation
  end


  def calculate_monetary_saving(burgers)
    original_total_int = Deal.total_int(burgers)
    value_currency_arr = self.value.split("")

    value_currency_arr.delete('£')
    value_currency_arr.delete('.')
    value_string = value_currency_arr.join
    value_int = value_string.to_i

    new_total_int = original_total_int - value_int
    calculation = {original_int: original_total_int, new_int: new_total_int}
    return calculation
  end


  def Deal.find_type(id)
    sql = "SELECT type FROM deal_types WHERE id = $1;"
    type_hash = SqlRunner.run(sql, [id]).first
    return type_hash['type']
  end


  def Deal.find_type_id(type)
    sql = "SELECT id FROM deal_types WHERE type = $1;"
    type_hash = SqlRunner.run(sql, [type]).first
    return type_hash['id'].to_i
  end


  def Deal.total_int(burgers)
    total = 0
    for burger in burgers
      total += burger.price_int
    end
    return total
  end


  # def Deal.active_deals_by_day(day_id)
  #   active_deals_array = []
  #   eatories = Eatory.find_all
  #   if eatories != []
  #     for eatory in eatories
  #       details_array = eatory.detail_all_deals_by_day(day_id)
  #       if details_array
  #         active_deals_array.push({"eatory" => eatory, 'active_deals' => details_array})
  #       end
  #     end
  #     if active_deals_array != []
  #       return active_deals_array
  #     end
  #   end
  #   return nil
  # end


  def Deal.find(id)
    sql = "
    SELECT * FROM deals
    WHERE id = $1;
    "
    deal_hash = SqlRunner.run(sql, [id]).first
    if deal_hash
      return Deal.new(deal_hash)
    end
    return nil
  end


  def Deal.find_all
    sql = "SELECT * FROM deals ORDER BY type_id ASC;"
    deal_hashes = SqlRunner.run(sql)
    return mapper_aid(deal_hashes)
  end


  def Deal.find_all_deal_types
    sql = "SELECT * FROM deal_types"
    deal_types_hashes = SqlRunner.run(sql)
    return deal_types_hashes
  end


  def Deal.find_all_labels
    sql = "SELECT DISTINCT label FROM deals;"
    label_hashes = SqlRunner.run(sql)
    labels = []
    label_hashes.each do |hash|
      labels.push(hash['label'])
    end
    return labels
  end


  def Deal.find_all_values
    sql = "SELECT DISTINCT value FROM deals;"
    value_hashes = SqlRunner.run(sql)
    values = []
    value_hashes.each do |hash|
      values.push(hash['value'])
    end
    return values
  end


  def Deal.find_by_burger(id)
  sql = "
  SELECT DISTINCT deals.id, deals.type_id, deals.label, deals.value, deals.day_id
  FROM deals INNER JOIN deals_eatories_burgers_prices ON deals_eatories_burgers_prices.deal_id = deals.id
  WHERE deals_eatories_burgers_prices.burger_id = $1 ORDER BY deals.type_id ASC;
  "
  deal_hashes = SqlRunner.run(sql, [id])
  return mapper_aid(deal_hashes)
  end


  def Deal.find_all_active
    sql = "
    SELECT DISTINCT d.* FROM deals d INNER JOIN
    deals_eatories_burgers_prices active ON
    active.deal_id = d.id WHERE active.deal_id
    IS NOT NULL ORDER BY d.type_id ASC;
    "
    deal_hashes = SqlRunner.run(sql)
    return mapper_aid(deal_hashes)
  end


  def Deal.find_all_inactive
    sql = "
    SELECT d.* FROM deals d WHERE NOT EXISTS
    (SELECT NULL
    FROM deals_eatories_burgers_prices active
    WHERE active.deal_id = d.id) ORDER BY d.type_id ASC;
    "
    deal_hashes = SqlRunner.run(sql)
    return mapper_aid(deal_hashes)
  end


  def Deal.find_all_active_by_day(day_id)
    sql = "
    SELECT DISTINCT deals.id, deals.type_id, deals.label, deals.value, deals.day_id
    FROM deals INNER JOIN deals_eatories_burgers_prices ON deals_eatories_burgers_prices.deal_id = deals.id
    WHERE deals.day_id = $1 ORDER BY deals.type_id ASC;
    "
    deal_hashes = SqlRunner.run(sql, [day_id])
    return mapper_aid(deal_hashes)
  end


  def self.mapper_aid(deal_hashes)
    deals = deal_hashes.map do |deal_hash|
      Deal.new(deal_hash)
    end
    if deals != []
      return deals
    end
    return nil
  end


end
