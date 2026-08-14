class PurchasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item
  before_action :set_purchase, only: [:destroy]

  def create
    if current_user.purchases.create item: @item
      redirect_to root_path, notice: "You bought #{@item.name}"
    end
  end

  def destroy
    if @purchase.destroy
      redirect_to root_path, notice: "You did not buy #{@item.name}"
    end
  end

  private

  def set_item
    @item = Item.find params[:item_id]
  end

  # Explicity scope to current user to prevent them from deleting others' purchases
  def set_purchase
    @purchase = current_user.purchases.find_by item: @item
  end

end
