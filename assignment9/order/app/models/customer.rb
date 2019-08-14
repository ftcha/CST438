class Customer
  
  include HTTParty
	
  # default_options.update(verify: false) # Turn off SSL verification
	base uri "http://localhost:8081"
	format :json
	
  def Customer.getCustomerByEmail(email)
    response = get "/customers?email=#{email}",
		          headers: {  "ACCEPT" => "application/json"}  
	  status = response.code
	  customer = JSON.parse response.body, symbolize_names: true 
	  # return status code and ruby hash with customer data
    return status, customer
  end 
  
  
  def Customer.putOrder(order) 
    # do put request to /customers/orders 
    response = put "/customers/order", 
                body:  order.to_json, 
                headers: { "CONTENT_TYPE" => "application/json" }
    response.code
  end
end
