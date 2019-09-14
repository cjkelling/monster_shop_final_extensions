class User::AddressesController < ApplicationController
  def new
    @user = current_user
    @address = current_user.addresses.new
  end

  def create
    @address = current_user.addresses.create(address_params)
    redirect_to "/users/#{current_user.id}"
  end

  def edit
    @user = current_user
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if !@address.shipped_order?
      flash[:notice] = 'Address is being shipped to. It cannot be updated at this time.'
      redirect_to "/users/#{current_user.id}"
    else
      @address.update(address_params)
      redirect_to "/users/#{current_user.id}"
    end
  end

  def destroy
    @address = Address.find(params[:id])
    if !@address.shipped_order?
      flash[:notice] = 'Address is being shipped to. It cannot be deleted at this time.'
      redirect_to "/users/#{current_user.id}"
    else
      @address.destroy
      redirect_to "/users/#{current_user.id}"
    end
  end

  private

  def address_params
    params.require(:address).permit(:address, :city, :state, :zip, :address_nickname)
  end
end
