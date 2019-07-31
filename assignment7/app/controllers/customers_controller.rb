class CustomersController < ApplicationController


  # POST /customers
  def create
    customerCreated = nil
    @customer = Customer.new
    @customer.email = params[:email]
    @customer.lastName = params[:lastName]
    @customer.firstName = params[:firstName]
    @customer.lastOrder = 0
    @customer.lastOrder2 = 0
    @customer.lastOrder3 = 0
    @customer.award = 0
    customerCreated = @customer.save

    if customerCreated
      render json: @customer.to_json, status:201
    else
      head 400
    end

  end


  # GET /customers?id=:id
  # GET /customers?email=:email
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
      render json: @customer.to_json, status:200
    else
      head 404
    end

  end

  # PUT /customers/order
  def processOrder
    @id = params[:customerId]
    @award = params[:award]
    @total = params[:total]
    @customer = Customer.find_by(id: @id)

    if @award == 0
      @customer.lastOrder3 = @customer.lastOrder2
      @customer.lastOrder2 = @customer.lastOrder
      @customer.lastOrder = @total

      if @customer.lastOrder3 != 0 && @customer.lastOrder2 != 0 &&
        @customer.lastOrder != 0
        @customer.award = 0.10 * (@customer.lastOrder + @customer.lastOrder2 + @customer.lastOrder3)/3.0
      end
    else
      @customer.award = 0
      @customer.lastOrder = 0
      @customer.lastOrder2 = 0
      @customer.lastOrder3 = 0
    end

    @customer.save

    head 204


  end

end