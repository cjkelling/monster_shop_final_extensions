class AddressController < ApplicationController
  def new; end

  def create
    @address = Address.create(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:address, :city, :state, :zip, :address_nickname)
  end
end
