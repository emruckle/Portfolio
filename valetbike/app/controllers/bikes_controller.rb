class BikesController < ApplicationController

  def index
    @bikes = Bike.all.order(identifier: :asc)
  end

  def return
    # gets return station id based on the parameter passed to return from the form
    station_id = params[:station_id] 
    # if return station id is valid
    if !Station.find_by(id: station_id).nil?
      # gets correct bike object based on id
      @bike = Bike.find(params[:id])
      # updates bike to reflect being returned
      @bike.update(status: "available", current_station_id: station_id)
      # gets current rental
      @rental = Rental.find(params[:current_rental_id])
      # if bike was returned late, set over_time = true
      if @rental.end_time < Time.now
        @rental.update(over_time: true)
      end
      @rental.update(end_time: Time.now)
      # change rental to inactive
      @rental.update(active: false)
      # get current user
      @user = User.find_by(id: session[:user_id])
      # calculate elapsed hours, divied by 3600 because ruby time is in seconds
      elapsed_hours = (Time.now - @rental.start_time) / 3600.0
      # update user hours to reflect ride
      @user.update_attribute(:hours, @user.hours + elapsed_hours)
      @rental.update_attribute(:duration, elapsed_hours * 60)
      # redirects the users back to the rental page
      redirect_to return_path
    else
      flash.alert = "Please enter a valid station ID."
      redirect_to rental_path(current_rental), status: :unprocessable_entity
    end
  end

end
