require_relative('../db/sqlrunner')
require_relative('burger')
require_relative('deal')

class Eatery

  attr_reader :id
  attr_accessor :name

  def initialize(options_hash)
    @id = options_hash['id'].to_i if options_hash['id']
    @name = options_hash['name']
  end


  def save
    sql = "
          INSERT INTO eateries (name)
          VALUES ($1)
          RETURNING id;
          "
    id_hash = SqlRunner.run(sql, [@name]).first
    @id = id_hash['id'].to_i
  end


  def update
    sql = "
          UPDATE eateries
          SET name = $1
          WHERE id = $2;
          "
    values = [@name, @id]
    SqlRunner.run(sql, values)
  end


  def delete
    sql = "
    DELETE FROM eateries
    WHERE id = $1;
    "
    SqlRunner.run(sql, [@id])
  end


  def add_stock(burgers_prices_hash)
    potential_ids = burgers_prices_hash.keys
    for potential_id in potential_ids
      burger_id = potential_id.to_i
      if burger_id != 0 && burgers_prices_hash[potential_id] != ""
          price_int = burgers_prices_hash[potential_id].to_i
          sql = "
          INSERT INTO active_deals
          (eatery_id, burger_id, price)
          VALUES ($1, $2, $3)
          "
          values = [@id, burger_id, price_int]
          SqlRunner.run(sql, values)
      end
    end
  end


  def remove_stock_and_return(burger_ids_in_hash)
    sql = "
    DELETE FROM active_deals
    WHERE burger_id = $1 AND eatery_id = $2;
    "
    changes = []
    keys = burger_ids_in_hash.keys
    for key in keys
      if key.to_i != 0
        burger_id = burger_ids_in_hash[key].to_i
        values = [burger_id, @id]
        SqlRunner.run(sql, values)
        changes.push(burger_id)
      end
    end
    return changes
  end


  def find_all_burgers
    sql = "
    SELECT DISTINCT b.*, active.eatery_id FROM active_deals active FULL JOIN burgers b
    ON b.id = active.burger_id
    WHERE eatery_id = $1
    ORDER BY id ASC;
    "
    burger_hashes = SqlRunner.run(sql, [@id])
    burgers_array = Burger.mapper_aid(burger_hashes)
    return burgers_array
  end


  def find_all_burgers_not_sold
    sql = "
    SELECT * FROM burgers WHERE burgers.id NOT IN
    (SELECT DISTINCT b.id FROM active_deals active FULL JOIN burgers b ON b.id = active.burger_id WHERE eatery_id = $1) ORDER BY id ASC;
    "
    burger_hashes = SqlRunner.run(sql, [@id])
    burgers_array = Burger.mapper_aid(burger_hashes)
    return burgers_array
  end


  def change_price( burger_price_hash )
    burger = burger_price_hash['burger']
    price = burger_price_hash['price'].to_i
    sql = "
    UPDATE active_deals
    SET price = $1 WHERE burger_id = $2 AND eatery_id = $3;
    "
    values = [price, burger.id, @id]
    SqlRunner.run(sql, values)
  end


  def check_burger_price(id)
    sql = "
    SELECT DISTINCT price
    FROM active_deals
    WHERE burger_id = $1 AND eatery_id = $2;
    "
    values = [id, @id]
    price_hash = SqlRunner.run(sql, values)[0]

    return price_hash['price'].to_i
  end


  def show_burger_price_currency(id)
    price_int = check_burger_price(id).to_s
    price_arr = price_int.split("")
    price_arr.unshift("£")
    price_arr.insert(-3,'.')
    price_currency = price_arr.join()
    return price_currency
  end


  def add_deal(options)
    sql = "
    INSERT INTO active_deals
    (deal_id, burger_id, eatery_id, price)
    VALUES ($1, $2, $3, $4);
    "
    keys = options.keys
    deal_id = options['deal_id'].to_i
    new_deals_burgers = {options['deal_id'] => []}

    for key in keys
      if key == 'deal_id'
        next
      end
      burger_id = key.to_i

      if burger_id != 0 && options[key] != ""
        price = check_burger_price(burger_id)
        values = [deal_id, burger_id, @id, price]
        SqlRunner.run(sql, values)
        burger = Burger.find(burger_id)
        new_deals_burgers[options['deal_id']].push(burger)

      end
    end
    if new_deals_burgers[options['deal_id']] != []
      return new_deals_burgers
    end
    return false
  end


  def find_deals
    sql ="
    SELECT DISTINCT deals.id, deals.label,
    deals.day_id, deals.value, deals.type_id
    FROM deals
    INNER JOIN active_deals ON
    active_deals.deal_id = deals.id
    AND active_deals.eatery_id
    = $1;
    "
    deal_hashes = SqlRunner.run(sql, [@id])
    deals = Deal.mapper_aid(deal_hashes)
    return deals
  end


  def find_all_inactive_deals
    sql = "
    SELECT * FROM deals WHERE deals.id NOT IN
    (SELECT DISTINCT d.id FROM active_deals active
    FULL JOIN deals d ON d.id = active.deal_id
    WHERE eatery_id = $1 AND d.id IS NOT NULL) ORDER BY type_id ASC;
    "
    deal_hashes = SqlRunner.run(sql, [@id])
    deals_array = Deal.mapper_aid(deal_hashes)
    return deals_array
  end


  def find_deals_by_day(day_id)
    sql ="
    SELECT DISTINCT deals.id, deals.label,
    deals.day_id, deals.value, deals.type_id
    FROM deals
    INNER JOIN active_deals ON
    active_deals.deal_id = deals.id
    AND active_deals.eatery_id
    = $1 AND deals.day_id = $2;
    "
    values = [@id, day_id]
    deal_hashes = SqlRunner.run(sql, values)
    deals = Deal.mapper_aid(deal_hashes)
    return deals
  end


  def find_deals_by_burger(burger_id)
    sql ="
    SELECT DISTINCT deals.id, deals.label,
    deals.day_id, deals.value, deals.type_id
    FROM deals
    INNER JOIN active_deals ON
    active_deals.deal_id = deals.id
    AND active_deals.eatery_id
    = $1 AND active_deals.burger_id = $2;
    "
    values = [@id, burger_id]
    deal_hashes = SqlRunner.run(sql, values)
    deals = Deal.mapper_aid(deal_hashes)
    return deals
  end


  def find_burgers_by_deal(deal_id)
    sql = "
    SELECT DISTINCT burgers.id,
    burgers.type, burgers.name,
    active_deals.price
    FROM burgers
    INNER JOIN active_deals ON active_deals.burger_id
    = burgers.id
    AND active_deals.eatery_id = $1
    AND active_deals.deal_id
    = $2;
    "
    values = [@id, deal_id]
    burger_hashes = SqlRunner.run(sql, values)
    return Burger.mapper_aid(burger_hashes)
  end


  def find_burgers_not_on_chosen_deal(deal_id)
    sql = "
    SELECT DISTINCT b.id, b.name, b.type FROM
    active_deals act FULL JOIN burgers b
    ON b.id = act.burger_id WHERE act.eatery_id = $1
    AND b.id NOT IN (SELECT DISTINCT b.id
    FROM active_deals act
    FULL JOIN burgers b ON b.id = act.burger_id
    WHERE act.eatery_id = $1 AND act.deal_id = $2);
    "
    values = [@id, deal_id]
    burger_hashes = SqlRunner.run(sql, values)
    return Burger.mapper_aid(burger_hashes)
  end


### modified since testing
  def remove_burgers_from_deal(options)
    sql = "
    DELETE FROM active_deals
    WHERE deal_id = $1
    AND burger_id = $2
    AND eatery_id = $3;
    "
    keys = options.keys
    deal_id = options['deal_id'].to_i
    removed_deal_burgers = []
    for key in keys
      burger_id = key.to_i
      if burger_id != 0
        values = [deal_id, burger_id, @id]
        SqlRunner.run(sql, values)
        burger = Burger.find(burger_id)
        removed_deal_burgers.push(burger)
      end
    end
    return removed_deal_burgers
  end


  def add_burgers_to_deal(options)
    sql = "
    INSERT INTO active_deals
    (deal_id, burger_id, eatery_id, price)
    VALUES ($1, $2, $3, $4);
    "
    keys = options.keys
    deal_id = options['deal_id'].to_i
    new_deal_burgers = []
    for key in keys
      burger_id = key.to_i
      if burger_id != 0
        price = check_burger_price(burger_id)
        values = [deal_id, burger_id, @id, price]
        SqlRunner.run(sql, values)
        burger = Burger.find(burger_id)
        new_deal_burgers.push(burger)
      end
    end
    return new_deal_burgers
  end


  def remove_deal(deal)
    sql = "
    DELETE FROM active_deals
    WHERE deal_id = $1
    AND eatery_id = $2;
    "
    values = [deal.id, @id]
    SqlRunner.run(sql, values)
  end


  def remove_several_deals(options)
    keys = options.keys
    removed_deals = []
    for key in keys
      potential_id = key.to_i
      if potential_id != 0 && options[key] != ""
        deal = Deal.find(potential_id)
        remove_deal(deal)
        removed_deals.push(deal)
      end
    end
    return removed_deals if removed_deals != []
    return false
  end


  def Eatery.find(id)
    sql = "
    SELECT * FROM eateries
    WHERE id = $1;
    "
    eatery_hash = SqlRunner.run(sql, [id]).first
    if eatery_hash != []
      return Eatery.new(eatery_hash)
    end
    return nil
  end


  def Eatery.find_by_burger(id)
    sql = "
    SELECT DISTINCT eateries.id, eateries.name
    FROM eateries INNER JOIN active_deals ON active_deals.eatery_id = eateries.id WHERE active_deals.burger_id = $1;
    "
    eatery_hashes = SqlRunner.run(sql, [id])
    return mapper_aid(eatery_hashes)
  end


  def Eatery.find_by_deal(id)
    sql = "
    SELECT DISTINCT eateries.id, eateries.name
    FROM eateries INNER JOIN active_deals ON active_deals.eatery_id = eateries.id WHERE active_deals.deal_id = $1;
    "
    eatery_hashes = SqlRunner.run(sql, [id])
    return mapper_aid(eatery_hashes)
  end


  def Eatery.find_by_burger_deal(options)
    sql = "
    SELECT eateries.id, eateries.name
    FROM eateries INNER JOIN active_deals ON active_deals.eatery_id = eateries.id WHERE active_deals.burger_id = $1 AND active_deals.deal_id = $2;
    "
    burger_id = options['burger'].to_i
    deal_id = options['deal'].to_i
    values = [burger_id, deal_id]
    eatery_hashes = SqlRunner.run(sql, values)
    return mapper_aid(eatery_hashes)
  end


  def Eatery.find_all
    sql = "SELECT * FROM eateries ORDER BY name ASC;"
    eatery_hashes = SqlRunner.run(sql)
    eateries = mapper_aid(eatery_hashes)
    return eateries
  end


  def Eatery.find_all_active
    sql = "
    SELECT DISTINCT e.* FROM eateries e INNER JOIN
    active_deals active ON
    active.eatery_id = e.id WHERE active.burger_id
    IS NOT NULL ORDER BY e.name ASC;
    "
    eatery_hashes = SqlRunner.run(sql)
    return mapper_aid(eatery_hashes)
  end


  def Eatery.find_all_inactive
    sql = "
    SELECT DISTINCT e.* FROM eateries e WHERE NOT EXISTS
    (SELECT * FROM active_deals active
    WHERE active.eatery_id = e.id) ORDER BY e.name ASC;
    "
    eatery_hashes = SqlRunner.run(sql)
    return mapper_aid(eatery_hashes)
  end


  def Eatery.show_only_newly_added_stock(old_stock, current_stock)
    changes = []
    if old_stock != nil
      for burger_current in current_stock
        is_new = true
        for burger_old in old_stock
          if burger_current.id == burger_old.id
            is_new = false
            break
          end
        end
        changes.push(burger_current) if is_new
      end
    return changes if changes != []
    return false
    end
  end


  def self.mapper_aid(eatery_hashes)
    eateries = []
    eatery_hashes.each do |hash|
      eatery = Eatery.new(hash)
      eateries.push(eatery)
    end
    if eateries != []
      return eateries
    end
    return nil
  end


end
