class StationsController < ApplicationController
  include StationsHelper
  def index
    if params[:sort] == "available_bikes"
      @stations = Station.all.sort_by { |station| count_available_bikes(station) }.reverse
    else
      @stations = Station.all.order(params[:sort])
    end
    @view = params[:view] || 'map'
  end

  def show
    @station = Station.find(params[:id])
  end

end
