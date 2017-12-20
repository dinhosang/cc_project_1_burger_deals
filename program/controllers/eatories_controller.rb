require('sinatra')
require('sinatra/contrib/all')
require_relative('../models/eatory')


get('/eatories') do
  @eatories = Eatory.find_all_active
  @inactive_eatories = Eatory.find_all_inactive
  erb(:"eatories/index")
end


post('/eatories') do
  @eatory = Eatory.new({'name' => params['name']})
  @eatory.save
  erb(:"eatories/create")
end


get('/eatories/new') do
  erb(:"eatories/new")
end


get('/eatories/:id') do
  id = params['id'].to_i
  @eatory = Eatory.find(id)
  @deals = @eatory.find_deals
  @burgers = @eatory.all_burgers
  erb(:"eatories/show")
end


post('/eatories/:id') do
  @changes = false
  id = params['id'].to_i
  @old_eatory = Eatory.find(id)
  @new_eatory = Eatory.find(id)
  if params['name'] != ""
    if params['name'] != @old_eatory.name
      @new_eatory.name = params['name']
      @changes = true
    end
  end
  @new_eatory.update if @changes
  erb(:"eatories/update")
end


post('/eatories/:id/delete') do
  @eatory = Eatory.find(params['id'])
  @eatory.delete
  erb(:"eatories/delete")
end


get('/eatories/:id/edit') do
  @eatory = Eatory.find(params['id'])
  erb(:"eatories/edit")
end

get('/eatories/:id/deals/edit') do
  @eatory = Eatory.find(params['id'].to_i)
  @stock = @eatory.all_burgers
  @inactive_deals = @eatory.find_all_inactive_deals
  @active_deals = @eatory.find_deals
  erb(:"eatories/deals/edit")
end


post('/eatories/:id/deals/update') do
  @eatory = Eatory.find(params['id'].to_i)
  @changes = @eatory.add_deal(params)
  if @changes
    deal_id_string = @changes.keys.first
    deal_id = deal_id_string.to_i
    @deal = Deal.find(deal_id)
    @burgers = @changes[deal_id_string]
  end
  erb(:"eatories/deals/update")
end


post('/eatories/:id/deals/delete') do
  @eatory = Eatory.find(params['id'].to_i)
  @deals = @eatory.remove_several_deals(params)
  erb(:"eatories/deals/delete")
end


get('/eatories/:eatory_id/deals/:deal_id') do
  eatory_id = params['eatory_id'].to_i
  deal_id = params['deal_id'].to_i
  @eatory = Eatory.find(eatory_id)
  @deal = Deal.find(deal_id)
  @burgers = @eatory.find_burgers_by_deal(deal_id)
  erb(:"eatories/deals/show")
end


get('/eatories/:id/burgers/edit') do
  @eatory = Eatory.find(params['id'].to_i)
  @unstocked_burgers = @eatory.find_all_burgers_not_sold
  @stocked_burgers = @eatory.all_burgers
  erb(:"eatories/burgers/edit")
end


post('/eatories/:id/burgers/update') do
  @eatory = Eatory.find(params['id'].to_i)
  old_stock = @eatory.all_burgers
  @eatory.add_stock(params)
  @current_stock = @eatory.all_burgers
  if old_stock != nil && @current_stock != nil
    @changes = Eatory.show_only_newly_added_stock(old_stock, @current_stock)
  elsif @current_stock != nil
    @changes = @current_stock
  else
    @changes = nil
  end
  erb(:"eatories/burgers/update")
end


post('/eatories/:id/burgers/delete') do
  @eatory = Eatory.find(params['id'])
  removed = @eatory.remove_stock_and_return(params)
  if removed != []
    @removed_burgers = Burger.find_several(removed)
  else
    @removed_burgers = false
  end
  erb(:"eatories/burgers/delete")
end


get('/eatories/:eatory_id/burgers/:burger_id/edit') do
  @burger = Burger.find(params['burger_id'].to_i)
  @eatory = Eatory.find(params['eatory_id'].to_i)
  erb(:"eatories/burgers/burger/edit")
end


post('/eatories/:eatory_id/burgers/:burger_id/update') do
  @burger = Burger.find(params['burger_id'].to_i)
  @eatory = Eatory.find(params['eatory_id'].to_i)
  @old_price_int = @eatory.check_burger_price(@burger.id)
  @new_price_int = params['price'].to_i
  @changes = false
  binding.pry
  if @old_price_int != @new_price_int
    @changes = true
    @old_price = @eatory.show_burger_price_currency(@burger.id)
    @eatory.change_price({'burger' => @burger, 'price' => params['price']})
    @new_price = @eatory.show_burger_price_currency(@burger.id)
  end
  erb(:"eatories/burgers/burger/update")
end


get('/eatories/:eatory_id/burgers/:burger_id') do
  eatory_id = params['eatory_id'].to_i
  burger_id = params['burger_id'].to_i
  @eatory = Eatory.find(eatory_id)
  @burger = Burger.find(burger_id)
  @deals = @eatory.find_deals_by_burger(burger_id)
  erb(:"eatories/burgers/show")
end
