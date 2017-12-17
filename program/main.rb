require('sinatra')
require('sinatra/contrib/all')
require_relative('controllers/deals_controller.rb')
require_relative('controllers/burgers_controller.rb')
require_relative('controllers/eatories_controller.rb')


get('/') do
  erb(:index)
end


not_found do
  status 404
  erb(:in_progress)
end
