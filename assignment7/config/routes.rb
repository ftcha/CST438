Rails.application.routes.draw do

  get '/customers' => 'customers#get'
  post '/customers' => 'customers#create'
  put '/customers/order' => 'customers#processOrder'

  get '/items' => 'items#get'
  post '/items' => 'items#create'
  put '/items' => 'items#update'
  put '/items/order' => 'items#updateItem'

end
