class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def arrive(train)
    @trains << train
  end

  def depart(train)
    @trains.delete(train)
  end

  def trains_by_type
    result_hash = Hash.new(0)
    trains.each { |train| result_hash[train.type] += 1 }
    result_hash
  end
end

class Route
  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
  end

  def first_station
    stations.first
  end

  def last_station
    stations.last
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def del_station(station)
    @stations.delete(station) unless [first_station, last_station].include?(station)
  end

  def stations_list
    stations.each { |x| puts x.name }
  end
end

class Train
  attr_reader :number, :type, :railcars_count, :speed, :route, :station

  def initialize(number, type, railcars_count)
    @number = number
    @type = type
    @railcars_count = railcars_count
    @speed = 0
    @route = nil
    @station = nil
  end

  def speed_up(speed_delta)
    @speed += speed_delta if speed_delta > 0
  end

  def stop
    @speed = 0
  end

  def attach_railcar
    @railcars_count += 1 if speed.zero?
  end

  def remove_railcar
    @railcars_count -= 1 if speed.zero? && railcars_count.positive?
  end

  def assign_route(route)
    @route = route
    @station = @route.first_station
    @station.arrive(self)
  end

  def goto_next_station
    if station
      @station.depart(self)
      @station = next_station
      @station.arrive(self)
    end
  end

  def goto_prev_station
    if station
      @station.depart(self)
      @station = prev_station
      @station.arrive(self)
    end
  end

  def prev_station
    @route.stations[@route.stations.find_index(@station) - 1] if route
  end

  def next_station
    @route.stations[@route.stations.find_index(@station) + 1] if route
  end
end
