require 'rails_helper'

RSpec.describe 'CustomersController', type: :request do

    it 'register a customer' do
        headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
        customer = { 'firstName' => 'Rspec', 'lastName' => 'Test', 'email' => 'rspecTest@gmail.com' }

        post '/customers', :params => customer.to_json, :headers => headers

        expect(response).to have_http_status(201)
        customer_response = JSON.parse(response.body)
        expect(customer_response).to include customer

        #verify database update
        customer = Customer.find_by(email: 'rspecTest@gmail.com')
        expect(customer).to be_truthy
        expect(customer.email).to eq 'rspecTest@gmail.com'
    end

    it 'duplicate email should fail' do
        headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

        Customer.create( firstName: 'Rspec', lastName: 'Test', email: 'rspecTest@gmail.com' )
        customer2 = {'firstName' => 'Rspec', 'lastName' => 'Test', 'email' => 'rspecTest@gmail.com' }

        post '/customers', :params => customer2.to_json, :headers => headers
        expect(response).to have_http_status(400)
        # customer_response = JSON.parse(response.body)
        # expect(customer_response).to have_key('messages')
    end

    it 'missing values for lastName, email should fail' do
        headers = { "CONTENT_TYPE" => "application/json", 'ACCEPT' => 'application/json' }
        customer = { 'firstName' => 'Greg' }
        post '/customers', :params => customer.to_json, :headers => headers
        expect(response).to have_http_status(400)
        #customer_response = JSON.parse(response.body)
        #expect(customer_response).to have_key('messages')
    end

    it 'retrieve customer by id' do
        headers = { "CONTENT_TYPE" => "application/json", 'ACCEPT' => 'application/json' }
        customer = Customer.create( firstName: 'Rspec', lastName: 'Test', email: 'rspecTest@gmail.com' )
        get '/customers?id=1', :headers => headers
        expect(response).to have_http_status(200)
        customer_response = JSON.parse(response.body)
        expect(customer_response['id']).to eq customer.id
        expect(customer_response['email']).to eq customer.email
    end

    it 'retrieve customer by id that does not exists fails' do
        get '/customers?id=99', :headers => headers
        expect(response).to have_http_status(404)
    end

    it 'retrieve customer by email' do
        headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
        customer = { 'firstName' => 'Rspec', 'lastName' => 'Test', 'email' => 'rspecTest@gmail.com' }
        customer = Customer.create( firstName: 'Rspec', lastName: 'Test', email: 'rspecTest@gmail.com' )
        get '/customers?email=rspecTest@gmail.com', :headers => headers
        expect(response).to have_http_status(200)
        customer_response = JSON.parse(response.body)
        expect(customer_response['id']).to eq customer.id
        expect(customer_response['email']).to eq customer.email
    end

    it 'retrieve customer by email that does not exists fails' do
        headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
        get '/customers?email=rspecTesty@gmail.com', :headers => headers
        expect(response).to have_http_status(404)
    end

    it 'customer makes 3 purchases and redeems award' do
        headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
        customer = Customer.create(firstName: 'Rspec',
                                   lastName: 'Test',
                                   email: 'rspecTest@gmail.com',
                                   lastOrder: 0,
                                   lastOrder2: 0,
                                   lastOrder3: 0,
                                   award: 0)

        lastOrder = { id: 1, customerId: customer.id, itemId: 1, price: 250.00, award: 0, total: 250.00 }
        put '/customers/order', :params => lastOrder.to_json, :headers => headers
        expect(response).to have_http_status(204)

        get "/customers?id=#{customer.id}", :headers => headers
        expect(response).to have_http_status(200)
        customer_response = JSON.parse(response.body)
        expect(customer_response['award']).to eq 0
        expect(customer_response['lastOrder']).to eq 250.00
        expect(customer_response['lastOrder2']).to eq 0
        expect(customer_response['lastOrder3']).to eq 0

        lastOrder2 = { id: 2, customerId: customer.id, itemId: 2, price: 120.00, award: 0, total: 120.00 }
        put '/customers/order', :params => lastOrder2.to_json, :headers => headers
        expect(response).to have_http_status(204)

        get "/customers?id=1", :headers => headers
        expect(response).to have_http_status(200)
        customer_response = JSON.parse(response.body)
        expect(customer_response['award']).to eq 0
        expect(customer_response['lastOrder']).to eq 120.00
        expect(customer_response['lastOrder2']).to eq 250.00
        expect(customer_response['lastOrder3']).to eq 0

        lastOrder3 = { id: 3, customerId: customer.id, itemId: 3, price: 490.00, award: 0, total: 490.00 }
        put '/customers/order', :params => lastOrder3.to_json, :headers => headers
        expect(response).to have_http_status(204)

        get "/customers?id=1", :headers => headers
        expect(response).to have_http_status(200)
        customer_response = JSON.parse(response.body)

        expect(customer_response['award']).to eq 28.67
        expect(customer_response['lastOrder']).to eq 490.00
        expect(customer_response['lastOrder2']).to eq 120.00
        expect(customer_response['lastOrder3']).to eq 250.00

        lastOrder4 = { id: 4, customerId: customer.id, itemId: 4, price: 200.00, award: 28.67, total: 171.33 }
        put '/customers/order', :params => lastOrder4.to_json, :headers => headers
        expect(response).to have_http_status(204)

        get "/customers?id=1", :headers => headers
        expect(response).to have_http_status(200)
        customer_response = JSON.parse(response.body)
        expect(customer_response['award']).to eq 0
        expect(customer_response['lastOrder']).to eq 0
        expect(customer_response['lastOrder2']).to eq 0
        expect(customer_response['lastOrder3']).to eq 0
    end

end