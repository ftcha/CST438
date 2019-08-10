Rails.application.routes.draw do
  post '/orders' => 'orders#create'
  get '/orders/:id' => 'orders#show'
  get '/orders' => 'orders#search'
end
