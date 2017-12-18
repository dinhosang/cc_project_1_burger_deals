require('sinatra')
require('sinatra/contrib/all')
require('date')
require('pry-byebug')
require_relative('controllers/deals_controller.rb')
require_relative('controllers/burgers_controller.rb')
require_relative('controllers/eatories_controller.rb')
require_relative('controllers/days_controller.rb')


get('/') do
  day_string = Time.new.strftime("%A")
  @day = Day.find_by_day(day_string)
  @deals = Deal.find_all_active_by_day(@day.id)
  # binding.pry
  erb(:index)
end

not_found do
  status 404
  erb(:in_progress)
end
