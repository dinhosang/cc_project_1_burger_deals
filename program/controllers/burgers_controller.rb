require('sinatra')
require('sinatra/contrib/all')
require('pry-byebug')
require_relative('../models/burger')


get('/burgers') do
  @burgers = Burger.find_all
  erb(:"burgers/index")
end


get('/burgers/:id') do
  id = params['id'].to_i
  @burger = Burger.find(id)
  @deals = Deal.find_by_burger(id)
  @eatories = Eatory.find_by_burger(id)
  erb(:"burgers/show")
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
