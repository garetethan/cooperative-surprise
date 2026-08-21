class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:update, :destroy]
  before_action :set_item_params, only: [:create, :update]

  def create
    @item = current_user.items.new @item_params
    if @item.save
      redirect_to root_path, notice: "Item created"
    else
      action_failed('create')
    end
  end

  def update
    if @item.update @item_params
      redirect_to root_path, notice: "#{@item.name} updated"
    else
      action_failed('update')
    end
  end

  def destroy
    if @item.destroy
      redirect_to root_path, notice: "#{@item.name} deleted"
    else
      action_failed('delete')
    end
  end

  private

  def set_item
    # Explicitly scope to the current user to prevent them from modifying other users' items
    @item = current_user.items.find params[:id]
  end

  def set_item_params
    # The item update forms all appear on one page, so they have distinct names
    item_symbol = request.patch? || request.put? ? "item_#{params[:id]}".to_sym : :item
    @item_params = params.require(item_symbol).permit(:priority, :name, :price, :description, :link, :plural)
  end

  def action_failed(action)
    redirect_to root_path, alert: "Unable to #{action} the item: #{@item.errors.full_messages.join('; ')}"
  end

end
