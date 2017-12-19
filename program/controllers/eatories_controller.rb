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


get('/eatories/:eatory_id/deals/:deal_id') do
  eatory_id = params['eatory_id'].to_i
  deal_id = params['deal_id'].to_i
  @eatory = Eatory.find(eatory_id)
  @deal = Deal.find(deal_id)
  @burgers = @eatory.find_burgers_by_deal(deal_id)
  erb(:"eatories/deals/show")
end


get('/eatories/:eatory_id/burgers/:burger_id') do
  eatory_id = params['eatory_id'].to_i
  burger_id = params['burger_id'].to_i
  @eatory = Eatory.find(eatory_id)
  @burger = Burger.find(burger_id)
  @deals = @eatory.find_deals_by_burger(burger_id)
  erb(:"eatories/burgers/show")
end
