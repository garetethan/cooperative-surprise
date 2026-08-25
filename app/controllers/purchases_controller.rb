class PurchasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item
  before_action :set_purchase, only: [:destroy]

  def create
    @purchase = current_user.purchases.create item: @item
    if @purchase.save
      redirect_to root_path, notice: "You bought #{@item.name}"
    elsif @purchase.errors.of_kind? :singular_conflict
      redirect_to purchase_conflict_path(@item)
    else
      action_failed("Could not mark #{@item.name} as bought")
    end
  end

  def conflict
    original_purchaser = Purchase.find_by(item: @item).user
    render :conflict, locals: { original_purchaser: original_purchaser }
  end

  def destroy
    if @purchase.destroy
      redirect_to root_path, notice: "You did not buy #{@item.name}"
    else
      action_failed("Could not mark #{@item.name} as not bought")
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

  def action_failed(message)
    redirect_to root_path, alert: "#{message}: #{@purchase.errors.full_messages.join(', ')}", status: :unprocessable_entity
  end

end
