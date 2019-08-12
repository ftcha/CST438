Rails.application.routes.draw do
  get '/items' => 'items#get'
  post '/items' => 'items#create'
  put '/items' => 'items#update'
  put '/items/order' => 'items#updateItem'
end
