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
    @type_id = options_hash['type_id'].to_i
    @type = Deal.find_type(@type_id)
    if @type != 'cheapest'
      @value = options_hash['value'] if options_hash['value']
    end
  end


  def value_string
    return "Cheapest Item is Free" if @type_id == 1
    return "#{@value} Off Order"
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


  def day
    sql = "SELECT * FROM days WHERE id = $1"
    day_hash = SqlRunner.run(sql, [@day_id])[0]
    return day_hash['day']
  end


  def check_and_edit_details(old_deal, params)

    changes = false

    if params['label'] != ""
      if params['label'] != old_deal.label
        @label = params['label']
        changes = true
      end
    end

    if params['value'] != ""
      if params['value'] != old_deal.value
        changes = true
        if params['value'] != "cheapest"
          @value = params['value']
        end
      end
    end

    if params['day_id'] != ""
      if params['day_id'] != old_deal.day_id
        @day_id = params['day_id'].to_i
        changes = true
      end
    end

    @type_id = type_id
    @type = Deal.find_type(type_id)

    if @type != old_deal.type
      changes = true
    end
    return changes
  end


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


  def Deal.find_type(id)
    sql = "SELECT type FROM deal_types WHERE id = $1;"
    type_hash = SqlRunner.run(sql, [id]).first
    return type_hash['type']
  end


  def Deal.find_all_deal_types
    sql = "SELECT * FROM deal_types"
    deal_types_hashes = SqlRunner.run(sql)
    return deal_types_hashes
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


  def Deal.find_all_active_by_day(day_id)
    sql = "
    SELECT DISTINCT deals.id, deals.type_id, deals.label, deals.value, deals.day_id
    FROM deals INNER JOIN deals_eatories_burgers_prices ON deals_eatories_burgers_prices.deal_id = deals.id
    WHERE deals.day_id = $1 ORDER BY deals.type_id ASC;
    "
    deal_hashes = SqlRunner.run(sql, [day_id])
    return mapper_aid(deal_hashes)
  end


  def Deal.find_all_inactive
    sql = "
    SELECT d.* FROM deals d WHERE NOT EXISTS
    (SELECT *
    FROM deals_eatories_burgers_prices active
    WHERE active.deal_id = d.id) ORDER BY d.type_id ASC;
    "
    deal_hashes = SqlRunner.run(sql)
    return mapper_aid(deal_hashes)
  end


  def Deal.check_correct_type_value(options)
    if options['value'] == 'cheapest' && options['type_id'] != '1'
      return false
    elsif options['value'] != 'cheapest' && options['type_id'] == '1'
      return false
    elsif options['value'].include?('/') && options['type_id'] != '2'
      return false
    elsif !options['value'].include?('/') && options['type_id'] == '2'
      return false
    end
    return true
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

###

# calculations methods

##
# Below calculation methods were made at
# start of planning when I thought user
# would make a basket of burgers to be told # how much of a saving they would have
#
# this was not needed as the saving value is
# shown as part of the deal and the
# calculation can be made by the user based
# on how many of and which burgers they
# desire.
#
# such functionality would have been nice,
# but would take more time than I have to
# implement
#
#
# def Deal.total_int(burgers)
#   total = 0
#   for burger in burgers
#     total += burger.price_int
#   end
#   return total
# end
#
# def calculate(burgers_arr)
#   if @type == "cheapest"
#     return false if burgers_arr.length < 2
#     calculation = calculate_cheapest_free(burgers_arr)
#   elsif type == "fraction"
#     calculation = calculate_fraction_saving(burgers_arr)
#   elsif type == "monetary"
#     calculation = calculate_monetary_saving(burgers_arr)
#   end
#   saving_amount_int = calculation[:original_int] - calculation[:new_int]
#   calculation[:saving_int] = saving_amount_int
#   return calculation
# end
#
#
# def calculate_cheapest_free(burgers)
#   original_total_int = Deal.total_int(burgers)
#   cheapest_burger = nil
#   for burger in burgers
#     if cheapest_burger != nil
#       if cheapest_burger.price_int > burger.price_int
#         cheapest_burger = burger
#       end
#     else
#       cheapest_burger = burger
#     end
#   end
#   burgers.delete(cheapest_burger)
#   after_saving_total_int = Deal.total_int(burgers)
#   calculation = {original_int: original_total_int, new_int: after_saving_total_int}
#   return calculation
# end
#
#
# def calculate_fraction_saving(burgers)
#   original = Deal.total_int(burgers)
#
#   fraction_array = self.value.split('/')
#   numerator = fraction_array[0].to_i
#   denominator = fraction_array[1].to_f
#
#   percent_mult = 1 - (numerator / denominator)
#   saving_unrounded = original * percent_mult
#
#   after_saving_total_int = saving_unrounded.round(0)
#
#   calculation = {original_int: original, new_int: after_saving_total_int}
#   return calculation
# end
#
#
# def calculate_monetary_saving(burgers)
#   original_total_int = Deal.total_int(burgers)
#   value_currency_arr = self.value.split("")
#
#   value_currency_arr.delete('£')
#   value_currency_arr.delete('.')
#   value_string = value_currency_arr.join
#   value_int = value_string.to_i
#
#   new_total_int = original_total_int - value_int
#   calculation = {original_int: original_total_int, new_int: new_total_int}
#   return calculation
# end
##

#

###

end
