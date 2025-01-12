class RentalsController < ApplicationController
  before_action :set_rental, only: %i[ show edit update destroy ]
  before_action :authenticate_user

  # GET /rentals or /rentals.json
  def index
    @rentals = Rental.all
    @user = User.find(session[:user_id])
  end

  # GET /rentals/1 or /rentals/1.json
  def show
    @rental = Rental.find(params[:id])
    @bike = Bike.find(@rental.id)
    @stations = Station.all
  end

  # GET /rentals/new
  def new
    @rental = Rental.new
  end

  # GET /rentals/1/edit
  def edit
  end

  # returns if the user has five rentals, false if less than, true if five
  def five_rentals?
    return (Rental.where(user_id: session[:user_id], active: true).count == 5)
  end

  # POST /rentals or /rentals.json
  def create
    @rental = Rental.new(rental_params)
    amount = rental_cost(@rental.duration)
    respond_to do |format|
    # check if user already has five active rentals, then display flash message and do not save rental
    if five_rentals?
      format.html do
        flash.alert = "You can only rent five bikes at once."
        redirect_to rentals_path, status: :unprocessable_entity
      end
      format.json { render json: @rental.errors, status: :unprocessable_entity }
    elsif (current_user.balance || 0) < amount
      format.html do
        flash.alert = "You do not have sufficient funds to rent this bike."
        redirect_to rentals_path, status: :unprocessable_entity
      end
      format.json { render json: @rental.errors, status: :unprocessable_entity }
    elsif @rental.save
      # if the rental is valid...
      # update user's balance to reflect purchase
      current_user.update_attribute(:balance, current_user.balance - amount)
      # update start and end time of rental
      @rental.update(start_time: @rental.created_at, end_time: @rental.created_at + @rental.duration.minutes, active: true)
      # find bike associated with rental, and update it so it is not at a station and is rented
      bike = Bike.find_by(id: @rental.bike_id)
      bike.update(status: "rented", current_station_id: nil)
      # redirct user to the page for their rental
      format.html { redirect_to rental_path(@rental), notice: "Rental was successfully created."}
    else
       # else, display flash alert and refresh the page for the current station
      format.html do
        flash.alert = "Please select a bike."
        redirect_to stations_path(@station), status: :unprocessable_entity
      end
      format.json { render json: @rental.errors, status: :unprocessable_entity }
    end
    end
  end

  # PATCH/PUT /rentals/1 or /rentals/1.json
  def update
    respond_to do |format|
      if @rental.update(rental_params)
        format.html { redirect_to rental_url(@rental), notice: "Rental was successfully updated." }
        format.json { render :show, status: :ok, location: @rental }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rental.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rentals/1 or /rentals/1.json
  def destroy
    @rental.destroy

    respond_to do |format|
      format.html { redirect_to rentals_url, notice: "Rental was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # cost of each rental duration
  def rental_cost(duration)
    case duration
      when 15
        return 2.0
      when 30
        return 3.0
      when 45
        return 4.0
      when 60
        return 5.0
      when 75
        return 6.0
      when 90
        return 7.0
      when 105
        return 8.0
      when 120
        return 9.0
      else
        return 0.0
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rental
      @rental = Rental.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rental_params
      params.require(:rental).permit(:bike_id, :end_time, :identifier, :start_time, :over_time, :user_id, :duration)
    end
end
