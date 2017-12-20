require('sinatra')
require('sinatra/contrib/all')
require_relative('../models/deal')
require_relative('../models/day')


get('/days') do
  @active_days = Day.find_all_active
  @inactive_days = Day.find_all_inactive
  erb(:"days/index")
end


get('/days/:id') do
  id = params['id'].to_i
  @day = Day.find(id)
  @deals = Deal.find_all_active_by_day(id)
  erb(:"days/show")
end
