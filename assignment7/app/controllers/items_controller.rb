class ItemsController < ApplicationController

  # POST /items
  def create
    itemCreated = nil
    @item = Item.new
    @item.description = params[:description]
    @item.price = params[:price]
    @item.stockQty = params[:stockQty]
    itemCreated = @item.save

    if itemCreated
      render json: @item.to_json, status:201
    else
      head 400
    end

  end


  # GET /items?id=:id
  def get

    @id = params[:id]
    @item = nil
    if !@id.nil?
      @item = Item.find_by(id: @id)
    end

    if !@item.nil?
      render json: @item.to_json, status:200
    else
      head 404
    end

  end

  # PUT /items
  def update
    @id = params[:itemId]
    @price = params[:price]
    @description = params[:description]
    @stockQty = params[:stockQty]

    @item = Item.find_by(id: @id)

    if !@item.nil?
      @item.description = @description
      @item.price = @price
      @item.stockQty = @stockQty
      @item.save

      render json: @item.to_json, status:204
    else
      head 404
    end
  end

   # PUT /items/order
  def updateItem
    @id = params[:itemId]
    @item = Item.find_by(id: @id)

    if !@item.nil?
      @item.stockQty -= 1
      @item.save
      head 204
    elsif @item.nil?
      head 404
    else
      head 400
    end
  end

end