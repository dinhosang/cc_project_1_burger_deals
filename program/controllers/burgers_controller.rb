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
  name = params['name'] if params['name'] != ""
  type = params['type']
  if params['name'] == "" && params['type'] == ""
    @changes = false
  else
    @burger = Burger.new({'name' => name, 'type' => type})
    @burger.save
  end
  erb(:"burgers/create")
end

get('/burgers/new') do
  @burger_types = Burger.find_all_types
  @burger_names = Burger.find_all_names
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
  @burger_types = Burger.find_all_types
  @burger_names = Burger.find_all_names
  erb(:"burgers/edit")
end

post('/burgers/:id') do
  @changes = true
  @old_burger = Burger.find(params['id'])
  @new_burger = Burger.find(params['id'])
  no_type = params['type'] == "" || params['type'] == nil
  no_name = params['name'] == "" || params['name'] == nil
  if no_type && no_name
    @changes = false
  elsif no_type
    @new_burger.name = params['name']
  elsif no_name
    @new_burger.type = params['type']
  else
    @new_burger.name = params['name']
    @new_burger.type = params['type']
  end
  @new_burger.update if @changes
  erb(:"burgers/update")
end

post('/burgers/:id/delete') do
  @burger = Burger.find(params['id'].to_i)
  @burger.delete
  erb(:"burgers/delete")
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
