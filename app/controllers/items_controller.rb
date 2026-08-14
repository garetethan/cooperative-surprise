class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:update, :destroy]
  before_action :set_item_params, only: [:create, :update]

  def create
    if current_user.items.create @item_params
      redirect_to root_path, notice: "Item created"
    else
      redirect_to root_path, alert: "Unable to create item", status: :bad_request
    end
  end

  def update
    if @item.update @item_params
      redirect_to root_path, notice: "#{@item.name} updated"
    else
      redirect_to root_path, alert: "Unable to update #{@item.name}", status: :bad_request
    end
  end

  def destroy
    if @item.destroy
      redirect_to root_path, notice: "#{@item.name} deleted"
    else
      redirect_to root_path, alert: "Unable to delete #{@item.name}", status: :bad_request
    end
  end

  private

  def set_item
    # Explicitly scope to the current user to prevent them from modifying other users' items
    @item = current_user.items.find params[:id]
  end

  def set_item_params
    @item_params = params.require(:item).permit(:name, :price, :description, :link, :plural)
  end

end
