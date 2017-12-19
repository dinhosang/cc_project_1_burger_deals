require('sinatra')
require('sinatra/contrib/all')
require_relative('../models/deal')


get('/deals') do
  @deals = Deal.find_all_active
  @inactive_deals = Deal.find_all_inactive
  erb(:"deals/index")
end


post('/deals') do
  @deal = Deal.new('type_id' => params['type_id'], 'value' => params['value'], 'day_id' => params['day_id'], 'label' => params['label'])
  @deal.save
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
  @eatories = Eatory.find_by_deal(id)
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
  changes = false
  @old_deal = Deal.find(id)
  @new_deal = Deal.find(id)

  if params['label'] != ""
    @new_deal.label = params['label']
    changes = true
  end
  if params['value'] != ""
    @new_deal.value = params['value']
    changes = true
  end
  if params['day_id'] != ""
    @new_deal.day_id = params['day_id'].to_i
    changes = true
  end

  @new_deal.type_id = type_id
  @new_deal.type = Deal.find_type(type_id)

  if @new_deal.type != @old_deal.type
    changes = true
  end

  @new_deal.update

  erb(:"deals/update")
end


post('/deals/:id/delete') do
  @deal = Deal.find(params['id'].to_i)
  @deal.delete
  erb(:"deals/delete")
end


get('/deals/:deal_id/eatories/:eatory_id') do
  eatory_id = params['eatory_id'].to_i
  deal_id = params['deal_id'].to_i
  @eatory = Eatory.find(eatory_id)
  @deal = Deal.find(deal_id)
  @burgers = @eatory.find_burgers_by_deal(deal_id)
  erb(:"deals/eatories/show")
end


get('/deals/:deal_id/burgers/:burger_id') do
  deal_id = params['deal_id'].to_i
  burger_id = params['burger_id'].to_i
  @deal = Deal.find(deal_id)
  @burger = Burger.find(burger_id)
  @eatories = Eatory.find_by_burger_deal({'burger' => burger_id, 'deal' => deal_id})
  erb(:"deals/burgers/show")
end
