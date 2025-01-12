class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :current_rental
  helper_method :active_rental?

  def current_user
    @current_user ||= session[:user_id] && User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    !current_user.nil?
  end

  def authenticate_user
    redirect_to login_path, flash: {alert: 'You must be signed in to rent a bike.'} if current_user.nil?
  end

  def current_rental
    # set current rental to the rental that matches current user id and is active
    # this hinges on users only having one active rental, if we allow uses more than one rental we will have to to change this
    @current_rental = Rental.find_by(user_id: session[:user_id], active: true)
  end
  
  def active_rental?
    # check if current_rental is nil, meaning current user has no active rentals
    !current_rental.nil?
  end

  # def redirect_if_authenticated
  #  redirect_to root_path, flash: { info: 'You are already logged in.'} if user_signed_in?
  # end
end
