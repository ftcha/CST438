class OrdersController < ApplicationController
   
    # POST /orders
    # POST /orders.json
    def create
        @order = Order.new
        code, customer = Customer.getCustomerByEmail(params[:email])
        
        if code != 200
            render json: {error: "Item id not found. #{params[:itemId] }" }, status: 400
            return
        end
        
        if item[:stockQty] <= 0
            render json: {error: "Item is out of stock."}, status: 400
            return
        end
        
        @order.itemId = params[:itemId]
        @order.description = item[:description]
        @order.customerId = customer[:customerId]
        @order.price = item[:price]
        @order.award = customer[:award]
        @order.total = @order.price - @order.award
        
        if @order.save
            code = Customer.putOrder(@order)
            code = Item.putOrder(@order)
            render json: @order, status: 201
        else
            render json: @order.errors, status: 400
        end
    end
   
   # GET /orders
    def show
        order = Order.find_by(id: params[:id])
        if order.nil?
           render json: {error: "Order not found. #{params[:id]}" }, status: 404
        else
            render json: order, status: 200
        end
    end
    
    # GET /orders
    # search by customerId or email
    def search
        customerId = params['customerId']
        email = params['email']
        if !email.nil?
            code, customer = Customer.getCustomerByEmail(email)
            if code !=200
                render json: {error: "Customer email not found. #{email}" }, status: 400
                return
            end
            customerId = customer[:id]
        end
        orders = Order.where(customerId: customerId)
        render json: orders, status: 200
    end
    
end