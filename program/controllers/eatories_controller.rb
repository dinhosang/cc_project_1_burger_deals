require('sinatra')
require('sinatra/contrib/all')
require_relative('../models/eatory')


get('/eatories') do
  @eatories = Eatory.find_all
  erb(:"eatories/index")
end


get('/eatories/:id') do
  id = params['id'].to_i
  @eatory = Eatory.find(id)
  @deals = @eatory.find_deals
  @burgers = @eatory.all_burgers
  erb(:"eatories/show")
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
