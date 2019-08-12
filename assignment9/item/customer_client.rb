require 'httparty'

class CustomerClient
    include HTTParty
    
    base_uri "http://localhost:8081"
    format :json
    
    def self.register(cust)
        post '/customers', body: cust.to_json, headers: { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' }
    end
    
    def self.getEmail(email)
        get "/customers?email=#{email}"
    end
    
    def self.getId(id)
        get "/customers?id=#{id}"
    end
    
end

while true
    puts "What do you want to do: register, email, id, or quit"
    cmd = gets.chomp!
    case cmd
        when 'quit'
            break
        when 'register'
            puts 'you want to register a new customer. now enter lastName, firstName, and email for new customer'
            cdata = gets.chomp!.split()
            response = CustomerClient.register lastName: cdata[0], firstName: cdata[1], email: cdata[2]
            puts "status code #{response.code}"
            puts response.body
        when 'email'
            puts 'you want to look up by email. now enter email address of customer'
            cdata = gets.chomp
            response = CustomerClient.getEmail(cdata)
            puts "status code #{response.code}"
            puts response.body
        when 'id'
            puts 'you want to look up by email. now enter id of customer'
            cdata = gets.chomp
            response = CustomerClient.getId(cdata)
            puts "status code #{response.code}"
            puts response.body
    end
end