class AddressesController < ApplicationController
  def new
    @address = Address.new
  end

  def create
    @address = current_user.addresses.create(address_params)
    redirect_to "/users/#{current_user.id}"
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    @address.update(address_params)
    redirect_to "/users/#{current_user.id}"
  end

  def destroy
    address = Address.find(params[:id])
    address.destroy
    redirect_to "/users/#{current_user.id}"
  end

  private

  def address_params
    params.require(:address).permit(:address, :city, :state, :zip, :address_nickname)
  end
end
