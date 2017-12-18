require('sinatra')
require('sinatra/contrib/all')
require_relative('../models/deal')


get('/deals') do
  @deals = Deal.find_all_active
  @inactive_deals = Deal.find_all_inactive
  erb(:"deals/index")
end


get('/deals/:id') do
  id = params['id'].to_i
  @deal = Deal.find(id)
  @eatories = Eatory.find_by_deal(id)
  @burgers = Burger.find_by_deal(id)
  erb(:"deals/show")
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
