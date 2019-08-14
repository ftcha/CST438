require 'rails_helper'

RSpec.describe "Orders", type: :request do
  describe "GET /orders" do
    before(:each) do
      order1 = Order.create(id: 1, itemId: 1, description: "unit test", customerId: 100, price: 1.50, award: 0, total: 1.50);
      order2 = Order.create(id: 2, itemId: 2, description: "unit test2", customerId: 100, price: 9.99, award: 0, total: 9.99)
    end
    it "get orders by id" do
      get '/orders/2',  headers: {"CONTENT_TYPE" => "application/json" ,
                                  "ACCEPT" => "application/json" }
      expect(response).to have_http_status(200)
      json_order = JSON.parse(response.body)
      expect(json_order['id']).to eq 2
    end

    it "get orders by customerId"  do
      get '/orders?customerId=100',  headers: {"CONTENT_TYPE" => "application/json" ,
                                  "ACCEPT" => "application/json" }
      expect(response).to have_http_status(200)
      json_orders = JSON.parse(response.body)
      expect(json_orders.size).to eq 2
    end

    it "get orders by customer email" do
      expect(Customer).to receive(:getCustomerByEmail).with('unitTest@csumb.edu') do
          [ 200, { id:  100, award: 0 } ]
      end
      get '/orders?email=unitTest@csumb.edu',  headers: {"CONTENT_TYPE" => "application/json" ,
                                  "ACCEPT" => "application/json" }
      expect(response).to have_http_status(200)
      json_orders = JSON.parse(response.body)
      expect(json_orders.size).to eq 2
    end
  end

  describe "POST /orders" do
    it "customer makes purchase" do
      order = { itemId: 100,
                email: 'dw@csumb.edu' }

      headers = {"CONTENT_TYPE" => "application/json" ,
                 "ACCEPT" => "application/json"}

      expect(Customer).to receive(:getCustomerByEmail).with('dw@csumb.edu') do
        [ 200, {'id' => 1, 'award'=> 0 } ]
      end

      expect(Item).to receive(:getItemById).with(100) do
        [ 200, { 'id'=>100, 'description'=>'jewelry item',
                      'price'=> 175.00, 'stockQty'=> 2 } ]
      end

      allow(Customer).to receive(:putOrder) do |order|
        expect(order.customerId).to eq 1
        201
      end

      allow(Item).to receive(:putOrder) do |order|
        expect(order.itemId).to eq 100
        201
      end

      post '/orders', params: order.to_json, headers: headers

      expect(response).to have_http_status(201)
      order_json = JSON.parse(response.body)
      expect(order_json).to include('itemId'=>100,
                                    'description'=>'jewelry item',
                                    'customerId'=> 1 ,
                                    'price'=>175.00,
                                    'award'=> 0,
                                    'total'=> 175.00 )

    end


    it "purchase has invalid customer email" do
      order = { itemId: 100,
                email: 'unitTest@csumb.edu' }

      headers = {"CONTENT_TYPE" => "application/json" ,
                 "ACCEPT" => "application/json"}

      expect(Customer).to receive(:getCustomerByEmail).with('unitTest@csumb.edu') do
        [ 404 , { }  ]
      end

      allow(Item).to receive(:getItemById) { [404, { }] }
      allow(Customer).to receive(:putOrder) { 201 }
      allow(Item).to receive(:putOrder) { 201 }
      expect(Customer).to_not have_received(:putOrder)
      expect(Item).to_not have_received(:putOrder)

      post '/orders', params: order.to_json, headers: headers

      expect(response).to have_http_status(400)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to be_truthy

    end

    it "purchase item that is not in stock" do

      order = { itemId: 100,
                email: 'unitTest@csumb.eduu' }

      headers = {"CONTENT_TYPE" => "application/json" ,
                 "ACCEPT" => "application/json"}

      expect(Customer).to receive(:getCustomerByEmail).with('unitTest@csumb.edu') do
        [ 200, {'id' => 1, 'award'=> 0 } ]
      end

      expect(Item).to receive(:getItemById).with(100) do
        [ 200, { 'id'=>100, 'description'=>'jewelry item',
                      'price'=> 175.00, 'stockQty'=> 0 } ]
      end

      allow(Customer).to receive(:putOrder)
      allow(Item).to receive(:putOrder)
      expect(Customer).to_not have_received(:putOrder)
      expect(Item).to_not have_received(:putOrder)

      post '/orders', params: order.to_json, headers: headers

      expect(response).to have_http_status(400)
      order_json = JSON.parse(response.body)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to be_truthy

    end

    it "purchase has invalid itemId" do
      order = { itemId: 100,
                email: 'unitTest@csumb.edu' }

      headers = {"CONTENT_TYPE" => "application/json" ,
                 "ACCEPT" => "application/json"}

      expect(Customer).to receive(:getCustomerByEmail).with('unitTest@csumb.edu') do
        [ 200, {'id' => 1, 'award'=> 0 } ]
      end

      allow(Item).to receive(:getItemById) { [404, { }] }
      allow(Customer).to receive(:putOrder) { 201 }
      allow(Item).to receive(:putOrder) { 201 }
      expect(Customer).to_not have_received(:putOrder)
      expect(Item).to_not have_received(:putOrder)

      post '/orders', params: order.to_json, headers: headers

      expect(response).to have_http_status(400)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to be_truthy

    end


  end
end