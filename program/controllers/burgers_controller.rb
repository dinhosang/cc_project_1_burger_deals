require('sinatra')
require('sinatra/contrib/all')
require('pry-byebug')
require_relative('../models/burger')


get('/burgers') do
  @active_burgers = Burger.find_all_active
  @inactive_burgers = Burger.find_all_inactive
  erb(:"burgers/index")
end

post('/burgers') do
  name = params['name'] if params['name']
  type = params['type']

  @burger = Burger.new({'name' => name, 'type' => type})
  @burger.save
  erb(:"burgers/create")
end

get('/burgers/new') do
  erb(:"burgers/new")
end


get('/burgers/:id') do
  id = params['id'].to_i
  @burger = Burger.find(id)
  @deals = Deal.find_by_burger(id)
  @eatories = Eatory.find_by_burger(id)
  erb(:"burgers/show")
end

get('/burgers/:id/edit') do
  id = params['id'].to_i
  @burger = Burger.find(id)
  erb(:"burgers/edit")
end

get('/burgers/:burger_id/deals/:deal_id') do
  burger_id = params['burger_id'].to_i
  deal_id = params['deal_id'].to_i
  @burger = Burger.find(burger_id)
  @deal = Deal.find(deal_id)
  @eatories = Eatory.find_by_burger_deal({'burger' => burger_id , 'deal' => deal_id})
  erb(:"burgers/deals/show")
end


get('/burgers/:burger_id/eatories/:eatory_id') do
  burger_id = params['burger_id'].to_i
  eatory_id = params['eatory_id'].to_i
  @burger = Burger.find(burger_id)
  @eatory = Eatory.find(eatory_id)
  @deals = @eatory.find_deals_by_burger(burger_id)
  erb(:"burgers/eatories/show")
end
