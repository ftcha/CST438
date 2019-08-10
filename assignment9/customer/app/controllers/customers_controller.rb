class CustomersController < ApplicationController
    
    # POST /customers
    def create
        @customer = Customer.new
        @customer.email = params[:email]
        @customer.lastName = params[:lastName]
        @customer.firstName = params[:firstName]
        @customer.award = 0
        @customer.lastOrder = 0
        @customer.lastOrder2 = 0
        @customer.lastOrder3 = 0
        @customer.save
        
        if @customer.save
            render json: @customer.to_json, status: 201
        else
            render json: {messages: @customer.errors.messages}, status: 400
        end
    end
    
    # GET /customers?email=:email
    # GET /customers?id=:id
    def get
        @id = params[:id]
        @email = params[:email]
        @customer = nil
        if !@id.nil?
            @customer = Customer.find_by(id: @id)
        elsif !@email.nil?
            @customer = Customer.find_by(email: @email)
        end
        if !@customer.nil?
            render json: @customer.to_json, status: 200
        else
            head 404
        end
    end
    
    # PUT /customers/order
    # request contains order data -> params
    def processOrder
        @id = params[:customerId]
        @award = params[:award]
        @total = params[:total]
        @customer = Customer.find_by(id: @id)
        if @award == 0
            @customer.lastOrder3 = @customer.lastOrder2
            @customer.lastOrder2 = @customer.lastOrder
            @customer.lastOrder = @total
            if (@customer.lastOrder != 0 && @customer.lastOrder2 != 0 && @customer.lastOrder3 != 0)
                @customer.award = 0.10 * (@customer.lastOrder.to_f + @customer.lastOrder2.to_f + @customer.lastOrder3.to_f)/3.0
            end
        else
            # award has been redeemed.
            # so set award, lastOrder=lastOrder2=lastOrder3 all to zero.
            @customer.award = 0
            @customer.lastOrder = 0
            @customer.lastOrder2 = 0
            @customer.lastOrder3 = 0
        end
        @customer.save
        head 204    # put was successfully processed
    end
    
end
