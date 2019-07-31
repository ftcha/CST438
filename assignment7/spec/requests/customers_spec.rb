require 'rails_helper'

RSpec.describe 'CustomersController', type: :request do

  it 'register a customer' do
    headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    customer = { 'firstName' => 'Blaze', 'lastName' => 'King', 'email' => 'blazeking@gmail.com' }

    post '/customers', :params => customer.to_json, :headers => headers

    expect(response).to have_http_status(201)
    customer_response = JSON.parse(response.body)
    puts customer_response
    expect(customer_response).to include customer

    #verify database update
    customer = Customer.find_by(email: 'blazeking@gmail.com')
    expect(customer).to be_truthy
    expect(customer.email).to eq 'blazeking@gmail.com'
  end

  it 'duplicate email should fail' do
    headers = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

    # create database record for bking
    Customer.create(firstName: 'Blaze',
                    lastName: 'King',
                    email: 'blazeking@gmail.com')
    customer2 ={'firstName' => 'Blaze',
                'lastName' => 'King',
                'email' => 'blazeking@gmail.com' }

    # attempt to create with duplicate email
    post '/customers', :params => customer2.to_json, :headers => headers

    expect(response).to have_http_status(400)
    puts response.body
    #customer_response = JSON.parse(response.body)
    # expect(customer_response).to have_key('messages')
  end

end