require('sinatra')
require('sinatra/contrib/all')
require_relative('../models/eatery')


get('/eateries') do
  @eateries = Eatery.find_all_active
  @inactive_eateries = Eatery.find_all_inactive
  erb(:"eateries/index")
end


post('/eateries') do
  @eatery = Eatery.new({'name' => params['name']})
  @eatery.save
  erb(:"eateries/create")
end


get('/eateries/new') do
  erb(:"eateries/new")
end


get('/eateries/:id') do
  id = params['id'].to_i
  @eatery = Eatery.find(id)
  @deals = @eatery.find_deals
  @burgers = @eatery.find_all_burgers
  erb(:"eateries/show")
end


post('/eateries/:id') do
  @changes = false
  id = params['id'].to_i
  @old_eatery = Eatery.find(id)
  @new_eatery = Eatery.find(id)
  if params['name'] != ""
    if params['name'] != @old_eatery.name
      @new_eatery.name = params['name']
      @changes = true
    end
  end
  @new_eatery.update if @changes
  erb(:"eateries/update")
end


post('/eateries/:id/delete') do
  @eatery = Eatery.find(params['id'])
  @eatery.delete
  erb(:"eateries/delete")
end


get('/eateries/:id/edit') do
  @eatery = Eatery.find(params['id'])
  erb(:"eateries/edit")
end

get('/eateries/:id/deals/edit') do
  @eatery = Eatery.find(params['id'].to_i)
  @stock = @eatery.find_all_burgers
  @inactive_deals = @eatery.find_all_inactive_deals
  @active_deals = @eatery.find_deals
  erb(:"eateries/deals/edit")
end


post('/eateries/:id/deals/update') do
  @eatery = Eatery.find(params['id'].to_i)
  @changes = @eatery.add_deal(params)
  if @changes
    deal_id_string = @changes.keys.first
    deal_id = deal_id_string.to_i
    @deal = Deal.find(deal_id)
    @burgers = @changes[deal_id_string]
  end
  erb(:"eateries/deals/update")
end


post('/eateries/:id/deals/delete') do
  @eatery = Eatery.find(params['id'].to_i)
  @deals = @eatery.remove_several_deals(params)
  erb(:"eateries/deals/delete")
end


get('/eateries/:eatery_id/deals/:deal_id') do
  eatery_id = params['eatery_id'].to_i
  deal_id = params['deal_id'].to_i
  @eatery = Eatery.find(eatery_id)
  @deal = Deal.find(deal_id)
  @burgers = @eatery.find_burgers_by_deal(deal_id)
  erb(:"eateries/deals/show")
end


get('/eateries/:eatery_id/deals/:deal_id/edit') do
  @eatery = Eatery.find(params['eatery_id'].to_i)
  @deal = Deal.find(params['deal_id'].to_i)
  @active_burgers = @eatery.find_burgers_by_deal(@deal.id)
  @inactive_burgers = @eatery.find_burgers_not_on_chosen_deal(@deal.id)
  erb(:"eateries/deals/deal/edit")
end


post('/eateries/:eatery_id/deals/:deal_id/update') do
  @changes = false
  keys = params.keys
  key_ints = keys.map {|key| key.to_i}
  keys_single_int = key_ints.join().to_i
  @eatery = Eatery.find(params['eatery_id'].to_i)
  @deal = Deal.find(params['deal_id'].to_i)
  if keys_single_int != 0
    @changes = true
    @new_burgers = @eatery.add_burgers_to_deal(params)
  end
  erb(:"eateries/deals/deal/update")
end


post('/eateries/:eatery_id/deals/:deal_id/delete') do
  @changes = false
  keys = params.keys
  key_ints = keys.map {|key| key.to_i}
  keys_single_int = key_ints.join().to_i
  @eatery = Eatery.find(params['eatery_id'].to_i)
  @deal = Deal.find(params['deal_id'].to_i)
  if keys_single_int != 0
    @changes = true
    @removed_burgers = @eatery.remove_burgers_from_deal(params)
  end
  erb(:"eateries/deals/deal/delete")
end


get('/eateries/:id/burgers/edit') do
  @eatery = Eatery.find(params['id'].to_i)
  @unstocked_burgers = @eatery.find_all_burgers_not_sold
  @stocked_burgers = @eatery.find_all_burgers
  erb(:"eateries/burgers/edit")
end


post('/eateries/:id/burgers/update') do
  @eatery = Eatery.find(params['id'].to_i)
  old_stock = @eatery.find_all_burgers
  @eatery.add_stock(params)
  @current_stock = @eatery.find_all_burgers
  if old_stock != nil && @current_stock != nil
    @changes = Eatery.show_only_newly_added_stock(old_stock, @current_stock)
  elsif @current_stock != nil
    @changes = @current_stock
  else
    @changes = nil
  end
  erb(:"eateries/burgers/update")
end


post('/eateries/:id/burgers/delete') do
  @eatery = Eatery.find(params['id'])
  removed = @eatery.remove_stock_and_return(params)
  if removed != []
    @removed_burgers = Burger.find_several(removed)
  else
    @removed_burgers = false
  end
  erb(:"eateries/burgers/delete")
end


get('/eateries/:eatery_id/burgers/:burger_id/edit') do
  @burger = Burger.find(params['burger_id'].to_i)
  @eatery = Eatery.find(params['eatery_id'].to_i)
  erb(:"eateries/burgers/burger/edit")
end


post('/eateries/:eatery_id/burgers/:burger_id/update') do
  @burger = Burger.find(params['burger_id'].to_i)
  @eatery = Eatery.find(params['eatery_id'].to_i)
  @old_price_int = @eatery.check_burger_price(@burger.id)
  @new_price_int = params['price'].to_i
  @changes = false
  if @old_price_int != @new_price_int
    @changes = true
    @old_price = @eatery.show_burger_price_currency(@burger.id)
    @eatery.change_price({'burger' => @burger, 'price' => params['price']})
    @new_price = @eatery.show_burger_price_currency(@burger.id)
  end
  erb(:"eateries/burgers/burger/update")
end


get('/eateries/:eatery_id/burgers/:burger_id') do
  eatery_id = params['eatery_id'].to_i
  burger_id = params['burger_id'].to_i
  @eatery = Eatery.find(eatery_id)
  @burger = Burger.find(burger_id)
  @deals = @eatery.find_deals_by_burger(burger_id)
  erb(:"eateries/burgers/show")
end
