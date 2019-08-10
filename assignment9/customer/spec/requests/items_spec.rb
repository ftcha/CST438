require 'rails_helper'

RSpec.describe 'ItemsController', type: :request do

    it 'create a item' do
        headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
        item = { 'description' => 'Rspec', 'price' => 2.99, 'stockQty' => 5 }

        post '/items', :params => item.to_json, :headers => headers

        expect(response).to have_http_status(201)
        item_response = JSON.parse(response.body)
        expect(item_response).to include item

        #verify database update
        item = Item.find_by(description: 'Rspec')
        expect(item).to be_truthy
        expect(item.price).to eq 2.99
    end

    it 'missing values for price, description should fail' do
        headers = { "CONTENT_TYPE" => "application/json", 'ACCEPT' => 'application/json' }
        item = { 'stockQty' => 3 }
        post '/items', :params => item.to_json, :headers => headers
        expect(response).to have_http_status(400)
    end

    it 'retrieve item by id' do
        headers = { "CONTENT_TYPE" => "application/json", 'ACCEPT' => 'application/json' }
        item = Item.create( description: "Rspec", price: 2.99, stockQty: 5 )
        get '/items?id=1', :headers => headers
        expect(response).to have_http_status(200)
        item_response = JSON.parse(response.body)
        expect(item_response['id']).to eq item.id
        expect(item_response['price']).to eq item.price
    end

    it 'retrieve item by id that does not exists fails' do
        get '/items?id=99', :headers => headers
        expect(response).to have_http_status(404)
    end

    it 'Update an item field' do
        headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
        Item.create( description: "Rspec", price: 2.99, stockQty: 5 )
        get '/items?id=1', :headers => headers
        expect(response).to have_http_status(200)
        item_response = JSON.parse(response.body)
        expect(item_response['price']).to eq 2.99

        itemData = { itemId: 1, description: "Rspec", price: 250.99, stockQty: 10 }
        put '/items', :params => itemData.to_json, :headers => headers
        expect(response).to have_http_status(204)

        get '/items?id=1', :headers => headers
        expect(response).to have_http_status(200)
        item_response = JSON.parse(response.body)
        expect(item_response['price']).to eq 250.99
    end

    it 'Update an item that does not exists, should fail' do
        headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
        itemData = { itemId: 99, description: "Rspec", price: 250.99, stockQty: 10 }
        put '/items', :params => itemData.to_json, :headers => headers
        expect(response).to have_http_status(404)
    end

    it 'Update an item stock' do
        headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
        Item.create( description: "Rspec", price: 2.99, stockQty: 5 )
        get '/items?id=1', :headers => headers
        expect(response).to have_http_status(200)
        item_response = JSON.parse(response.body)
        expect(item_response['stockQty']).to eq 5

        itemData = { itemId: 1 }
        put '/items/order', :params => itemData.to_json, :headers => headers
        expect(response).to have_http_status(204)

        get '/items?id=1', :headers => headers
        expect(response).to have_http_status(200)
        item_response = JSON.parse(response.body)
        expect(item_response['stockQty']).to eq 4
    end

    it 'Update an item stock that does not exists, should fail' do
        headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
        itemData = { itemId: 99 }
        put '/items/order', :params => itemData.to_json, :headers => headers
        expect(response).to have_http_status(404)
    end

end