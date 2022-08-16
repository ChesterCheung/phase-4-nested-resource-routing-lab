class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items
    else
    item = Item.all
  end
  render json: item, include: :user
end

def show
  item = Item.find_by(id: params[:id])
  if item
  render json: item
  else 
    render json: {error: "Item not found"}, status: :not_found
  end
end

def create
    user = User.find(params[:user_id])
    item = user.items.create(item_params)
    render json: item, status: :created
end

def render_not_found_response(exception)
  render json: {error: "#{exception.model} not found" }, status: :not_found
end

private

def item_params
  params.permit(:name, :description, :price, :user_id)
end

end