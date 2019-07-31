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

    @item.description = @description
    @item.price = @price
    @item.stockQty = @stockQty

    @item.save

    if !@item.nil?
      render json: @item.to_json, status:204
    else
      head 404
    end
  end

   # PUT /items/order
  def updateItem
    itemUpdate = nil
    @id = params[:itemId]
    @item = Item.find_by(id: @id)

    @item.stockQty -= 1

    itemUpdate = @item.save

    if itemUpdate
      head 204
    elsif @item.nil?
      head 404
    else
      head 400
    end
  end

end