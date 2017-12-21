require('sinatra')
require('sinatra/contrib/all')
require_relative('../models/deal')


get('/deals') do
  @deals = Deal.find_all_active
  @inactive_deals = Deal.find_all_inactive
  erb(:"deals/index")
end


post('/deals') do
  @deal = Deal.new(
    'type_id' => params['type_id'],
    'value' => params['value'],
    'day_id' => params['day_id'],
    'label' => params['label']
  )
  @correct = Deal.check_correct_type_value(params)
  @deal.save if @correct
  erb(:"deals/create")
end


get('/deals/new') do
  @deal_type_hashes = Deal.find_all_deal_types
  @day_objects = Day.find_all
  @deal_labels = Deal.find_all_labels
  @deal_values = Deal.find_all_values
  erb(:"deals/new")
end


get('/deals/:id') do
  id = params['id'].to_i
  @deal = Deal.find(id)
  @eateries = Eatery.find_by_deal(id)
  @burgers = Burger.find_by_deal(id)
  erb(:"deals/show")
end


get('/deals/:id/edit') do
  id = params['id'].to_i
  @deal = Deal.find(id)
  @deal_type_hashes = Deal.find_all_deal_types
  @day_objects = Day.find_all
  @deal_labels = Deal.find_all_labels
  @deal_values = Deal.find_all_values
  erb(:"deals/edit")
end


post('/deals/:id') do
  id = params['id'].to_i
  type_id = params['type_id'].to_i
  @old_deal = Deal.find(id)
  @new_deal = Deal.find(id)

  @correct = Deal.check_correct_type_value(params)

  if @correct
    @changes = @new_deal.check_and_edit_details(@old_deal, params)
  end

  @new_deal.update if @changes

  erb(:"deals/update")
end


post('/deals/:id/delete') do
  @deal = Deal.find(params['id'].to_i)
  @deal.delete
  erb(:"deals/delete")
end


get('/deals/:deal_id/eateries/:eatery_id') do
  eatery_id = params['eatery_id'].to_i
  deal_id = params['deal_id'].to_i
  @eatery = Eatery.find(eatery_id)
  @deal = Deal.find(deal_id)
  @burgers = @eatery.find_burgers_by_deal(deal_id)
  erb(:"deals/eateries/show")
end


get('/deals/:deal_id/burgers/:burger_id') do
  deal_id = params['deal_id'].to_i
  burger_id = params['burger_id'].to_i
  @deal = Deal.find(deal_id)
  @burger = Burger.find(burger_id)
  @eateries = Eatery.find_by_burger_deal({'burger' => burger_id, 'deal' => deal_id})
  erb(:"deals/burgers/show")
end
