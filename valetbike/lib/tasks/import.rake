require 'csv'

desc "Import station and bike data"
task initial_import: [:environment] do
  # Import initial data from CSV files
  CSV.foreach(("./notes/station-data.csv"), headers: true, col_sep: ",") do |row|
    s = Station.new(identifier: row[0], name: row[1], address: row[6],lat: row[7],long: row[8])
    s.save!
  end
  CSV.foreach(("./notes/bike-data.csv"), headers: true, col_sep: ",") do |row|
    b = Bike.new(identifier: row[0], current_station: Station.find_by(identifier: row[1]))
    b.save!
  end
  CSV.foreach(("./notes/user-data.csv"), headers: true, col_sep: ",") do |row|
    u = User.new(identifier: row[0], username: row[1],first: row[2],last: row[3], email: row[4], password: row[5])
    u.save!
  end

  CSV.foreach(("./notes/rental-data.csv"), headers: true, col_sep: ",") do |row|
    r = Rental.new(identifier: row[0], user: User.find_by(identifier: row[1]), bike: Bike.find_by(identifier: row[2]), start_time: row[3], end_time: row[4], over_time: row[5], duration: row[6])
    r.save!
  end

  # set charges pseudo-randomly (ensure 0 and 100 exist)
  Bike.select{|b| b[:identifier]<10000}.each do |b|
    b.charge=rand(0...100)
    b.save!
  end
  Bike.select{|b| b[:identifier]<1000}.each do |b|
    b.charge=0
    b.save!
  end
  Bike.select{|b| b[:identifier]>9000}.each do |b|
    b.charge=100
    b.save!
  end

  # if bike mostly charged
  Bike.select{ |bike| bike.charge>=50}.each do |b|
    b.update(status: "available")
    b.save!
  end
  # if bike not mostly charged
  Bike.select{ |bike| bike.charge<50}.each do |b|
    b.update(status: "charging")
    b.save!
  end
  # arbitrary bikes to service
  Bike.select{ |bike| bike.identifier%5==0}.each do |b|
    b.update(status: "service")
    b.save!
  end
  # if bike being rented
  Bike.select{ |bike| bike.current_station_id.nil? }.each do |b|
    b.update(status: "rented")
    b.save!
  end

  # give each station a capacity at least equal to the number of current bikes + 1
  Station.select{ |station| station.capacity.nil? }.each do |s|
    current = s.docked_bikes.select{ |bike| bike }.count
    s.update(capacity: current + rand(1...5))
    s.save!
  end



end