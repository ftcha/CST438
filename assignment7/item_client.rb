require 'httparty'

class ItemClient
  include HTTParty

  base_uri "http://localhost:8080"
  format :json

  def self.create(i)
    post '/items', body: i.to_json,
      headers: { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }

  end

  def self.getId(id)
    get "/items?id=#{id}"
  end

  def self.update(i)
    put '/items', body: i.to_json,
      headers: { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }
  end

end

while true
  puts "What do you want to do: create, update, get or quit?"
  cmd = gets.chomp!
  case cmd
  when 'quit'
    break
  when 'create'
    puts
    puts 'Enter item description'
    desc = gets.chomp

    puts 'Enter item price'
    price = gets.chomp

    puts 'Enter item stockQty'
    stock = gets.chomp

    response = ItemClient.create description: desc, price: price, stockQty: stock
    puts "status code #{response.code}"
    puts response.body
    puts
  when 'get'
    puts
    puts 'Enter id of item to lookup'
    cdata = gets.chomp!.split()

    response = ItemClient.getId(cdata[0])
    puts "status code #{response.code}"
    puts response.body
    puts
  when 'update'
    puts
    puts 'enter id of item to update'
    id = gets.chomp!.split()

    puts 'Enter description'
    desc = gets.chomp

    puts 'Enter price'
    price = gets.chomp

    puts 'Enter stockQty'
    stock = gets.chomp

    response = ItemClient.update itemId: id, description: desc, price: price, stockQty: stock
    puts "status code #{response.code}"
    puts response.body
    puts

  end
end

