module StationsHelper
  def count_available_bikes(station)
    return station.docked_bikes.select{ |bike| bike[:status] == "available" }.count
  end

  def bikes_available_sorted(station)
    return station.docked_bikes.select{ |bike| bike[:status] == "available"}.sort_by{|bike| -bike.charge}
  end
end
