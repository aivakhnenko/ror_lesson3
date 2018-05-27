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
    trains_by_type = Hash.new(0)
    @trains.each { |x| trains_by_type[x.type] += 1 }
    trains_by_type
  end
end

class Route
  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
  end

  def first_station
    @stations[0]
  end

  def last_station
    @stations[-1]
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def del_station(station)
    @stations.delete(station) if (station != @stations[0]) && (station != @stations[-1])
  end

  def stations_list
    @stations.each { |x| puts x.name }
  end
end

class Train
  attr_reader :number, :type, :cars_count, :speed, :route, :station

  def initialize(number, type, cars_count)
    @number = number
    @type = type
    @cars_count = cars_count
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

  def attach_car
    @cars_count += 1 if @speed == 0
  end

  def remove_car
    @cars_count -= 1 if (@speed == 0) && (cars_count > 0)
  end

  def assign_route(route)
    @route = route
    @station = @route.first_station
    @station.arrive(self)
  end

  def goto_next_station
    if @station
      @station.depart(self)
      @station = next_station
      @station.arrive(self)
    end
  end

  def goto_prev_station
    if @station
      @station.depart(self)
      @station = prev_station
      @station.arrive(self)
    end
  end

  def prev_station
    @route.stations[@route.stations.find_index(@station) - 1] if @route
  end

  def next_station
    @route.stations[@route.stations.find_index(@station) + 1] if @route
  end
end
