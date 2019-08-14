require 'httparty'

class OrderClient
  include HTTParty
  
  base_uri "http://localhost:8080"
	format :json
 
  def self.create(order) 
    post '/orders', body: order.to_json, headers:  { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }
  end 
  
  def self.getId(id)
    get "/orders/#{id}", headers:  { 'ACCEPT' => 'application/json' }
  end
end 

class ItemClient 
  include HTTParty
  
  base_uri "http://localhost:8082"
	format :json
 
  def self.create(item) 
    post '/items', body: item.to_json, headers:  { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }
  end 
  
  def self.update(item)
     put "/items/#{item[:id]}", body: item.to_json, headers:  { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }
  end
  
  def self.getId(id)
    get "/items/?id=#{id}", headers:  { 'ACCEPT' => 'application/json' }
  end
end 

class CustomerClient 
  include HTTParty
  
  base_uri "http://localhost:8081"
	format :json
  
  def self.register(cust)
    post '/customers', body: cust.to_json, headers:  { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }
  end 
  
  def self.getEmail(email)
    get "/customers?email=#{email}", headers:  { 'ACCEPT' => 'application/json' }
  end
  
  def self.getId(id)
    get "/customers?id=#{id}", headers:  { 'ACCEPT' => 'application/json' }
  end
end 

command = true

while command 
  puts "What do you want to do: (1) New Order, (2) Retrieve Order, (3) Register Customer, (4) Lookup Customer, (5) Create Item, (6) Lookup Item, (7) Exit"
  cmd = gets.chomp! 
  puts  
  case cmd
    when '1'
      puts 'Please enter the Item ID'
      itemId = gets.chomp!
      puts 'enter email'
      email = gets.chomp!
      response = OrderClient.create itemId: itemId, email: email
      puts "status code #{response.code}"
      puts response.body unless response.code==500
      puts
      
    when '2'
      puts 'Please enter Order ID to lookup'
      id = gets.chomp!
      response = OrderClient.getId(id)
      puts "status code #{response.code}"
      puts response.body unless response.code==500
      puts
        
    when '3'
      puts 'Register a new customer - Please enter Last Name, First Name, Email Address - separate by space'
      cdata = gets.chomp!.split()
      response = CustomerClient.register lastName: cdata[0], firstName: cdata[1], email: cdata[2] 
      puts "status code #{response.code}"
      puts response.body  unless response.code==500
      puts
    
    when '4'
      puts 'Please enter Customer ID or Email Address'
      cid = gets.chomp!
      if cid.include?('@')
        response = CustomerClient.getEmail(cid)
      else 
        response = CustomerClient.getId(cid)
      end 
      puts "status code #{response.code}"
      puts response.body unless response.code==500
      puts
      
    when '5'
      puts 'Please enter Item Description, Price, Stock - separate by space'
      idata = gets.chomp!.split()
      response = ItemClient.create description: idata[0], price: idata[1], stockQty: idata[2]
      puts "status code #{response.code}"
      puts response.body unless response.code==500
      puts
    
    when '6'
      puts 'Please enter Item ID to lookup'
      id = gets.chomp!
      response = ItemClient.getId(id)
      puts "status code #{response.code}"
      puts response.body unless response.code==500
      puts
    
    when '7'
      command = false
  end 
end 