require 'httparty'

class OrderClient
  include HTTParty
  
  base_uri "http://localhost:8080"
	format :json
 
  def self.create(order) 
    post '/orders', body: order.to_json, 
         headers:  { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }
  end 
  
  def self.getId(id)
    get "/orders/#{id}" , 
      headers:  { 'ACCEPT' => 'application/json' }
  end
end 

class ItemClient 
  include HTTParty
  
  base_uri "http://localhost:8082"
	format :json
 
  def self.create(item) 
    post '/items', body: item.to_json, 
         headers:  { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }
  end 
  
  def self.update(item)
     put "/items/#{item[:id]}", body: item.to_json, 
         headers:  { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }
  end
  
  def self.getId(id)
    get "/items/?id=#{id}" , 
      headers:  { 'ACCEPT' => 'application/json' }
  end
end 

class CustomerClient 
  include HTTParty
  
  base_uri "http://localhost:8081"
	format :json
  
  def self.register(cust)
    post '/customers', body: cust.to_json, 
         headers:  { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }
  end 
  
  def self.getEmail(email)
    get "/customers?email=#{email}" ,
      headers:  { 'ACCEPT' => 'application/json' }
  end
  
  def self.getId(id)
    get "/customers?id=#{id}" , 
      headers:  { 'ACCEPT' => 'application/json' }
  end
end 

command = true

while command 
  puts "What do you want to do: (1) Register customer, (2) Item create, (3) Purchase, (4) Customer lookup, (5) Item lookup, (6) Order lookup, or quit?"
  cmd = gets.chomp! 
  puts  
  case cmd
    when 'quit'
      command = false
    when '1'  # register customer
      puts 'register customer. enter lastName firstName email. Separate the fields with a blank space.'
      cdata = gets.chomp!.split()
      response = CustomerClient.register lastName: cdata[0], firstName: cdata[1], email: cdata[2] 
      puts "status code #{response.code}"
      puts response.body  unless response.code==500
      puts
      
    when '2'  # create item
      puts 'enter item description price stockQty.  Separate the fields with a blank space.'
      idata = gets.chomp!.split()
      response = ItemClient.create description: idata[0], price: idata[1], stockQty: idata[2]
      puts "status code #{response.code}"
      puts response.body unless response.code==500
      puts
    
    when '3'  # create an order
      puts 'enter item id'
      itemId = gets.chomp!
      puts 'enter email'
      email = gets.chomp!
      response = OrderClient.create itemId: itemId, email: email
      puts "status code #{response.code}"
      puts response.body unless response.code==500
      puts 
      
    when '4'  # lookup customer
      puts 'enter customer id or email'
      cid = gets.chomp!
      if cid.include?('@')
        response = CustomerClient.getEmail(cid)
      else 
        response = CustomerClient.getId(cid)
      end 
      puts "status code #{response.code}"
      puts response.body unless response.code==500
      puts
        
    when '5'  # lookup item
      puts 'enter id of item to lookup'
      id = gets.chomp!
      response = ItemClient.getId(id)
      puts "status code #{response.code}"
      puts response.body unless response.code==500
      puts
    
    when '6'  # lookup order 
      puts 'enter id of order to lookup'
      id = gets.chomp!
      response = OrderClient.getId(id)
      puts "status code #{response.code}"
      puts response.body unless response.code==500
      puts

    else
      puts "I don't understand.  Enter the number of the action to perform (ex.  3  ) or quit" 
      puts
  end 
end 