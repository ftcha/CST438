class Item
    include HTTParty
    base_uri "http://localhost:8082"
    format :json

    def self.getItemById(id)
        response = get "/items/?id=#{id}", headers: {"ACCEPT" => "application/json"}
        status = response.code
        item = JSON.parse response.body, symbolize_names: true
        return status, item
    end

    def self.putOrder(order)
        response = put "/items/order", body: order.to_json, headers: {"CONTENT_TYPE" => "application/json"}
        response.code
    end

end