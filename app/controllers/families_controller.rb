class FamiliesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_administered_family

  def edit
  end

  def update
    if @administered_family.update(administered_family_params)
      redirect_to root_path, notice: 'Record was successfully updated'
    else
      render :edit
    end
  end

  private

  def set_administered_family
    @administered_family = current_user.administered_family
    if @administered_family.nil?
      redirect_to root_path, alert: 'You are not an admin of your family, so you cannot edit it.'
    end
    @administered_family
  end

  def administered_family_params
    params.require(:family).permit(:name)
  end

end
