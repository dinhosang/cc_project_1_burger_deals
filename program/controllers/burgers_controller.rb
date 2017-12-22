require('sinatra')
require('sinatra/contrib/all')
require('pry-byebug')
require_relative('../models/burger')


get('/burgers') do
  @active_burgers = Burger.find_all_active
  @inactive_burgers = Burger.find_all_inactive
  erb(:"burgers/index")
end


get('/burgers/new') do
  @burger_types = Burger.find_all_types
  @burger_names = Burger.find_all_names
  erb(:"burgers/new")
end


post('/burgers') do
  @changes = true
  if params['name'] == "" && params['type'] == ""
    @changes = false
  end
  type = params['type']
  check = type.split(" ")
  if check == []
    @changes = false
  else
    @burger = Burger.new(params)
    @burger.save
  end
  erb(:"burgers/create")
end


get('/burgers/:id') do
  id = params['id'].to_i
  @burger = Burger.find(id)
  @deals = Deal.find_by_burger(id)
  @eateries = Eatery.find_by_burger(id)
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
  @changes = false
  @old_burger = Burger.find(params['id'])
  @new_burger = Burger.find(params['id'])

  no_type = params['type'] == "" || params['type'] == nil
  no_name = params['name'] == "" || params['name'] == nil

  if params.keys.include?('remove_name')
    if @old_burger.name != nil
      @changes = 'name'
      @new_burger.name = nil
    end
  elsif !no_name && !no_type
    if params['name'] != @old_burger.name
      @new_burger.name = params['name']
      @changes = true
    end
    if params['type'] != @old_burger.type
      @new_burger.type = params['type']
      @changes = true
    end
  elsif !no_name
    if params['name'] != @old_burger.name
      @new_burger.name = params['name']
      @changes = true
    end
  elsif !no_type
    if params['type'] != @old_burger.type
      @new_burger.type = params['type']
      @changes = true
    end
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
  @eateries = Eatery.find_by_burger_deal({'burger' => burger_id , 'deal' => deal_id})
  erb(:"burgers/deals/show")
end


get('/burgers/:burger_id/eateries/:eatery_id') do
  burger_id = params['burger_id'].to_i
  eatery_id = params['eatery_id'].to_i
  @burger = Burger.find(burger_id)
  @eatery = Eatery.find(eatery_id)
  @deals = @eatery.find_deals_by_burger(burger_id)
  erb(:"burgers/eateries/show")
end
