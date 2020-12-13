class Train
  require_relative 'manufacturer'
  require_relative 'instance_counter'
  require_relative 'validation'

  include Manufacturer
  include InstanceCounter
  include Validation

  attr_reader :speed, :route, :number, :cars, :station_number

  TRAIN_NUMBER = /^\w{3}-?\w{2}$/.freeze  # три буквы/цифры, необязательный дефис, 2 буквы/цифры.

  validate :number, :format, TRAIN_NUMBER

  @@all_trains = []

  def self.find(train_number)
    @@all_trains.select { |t| t.number == train_number }[0]
  end

  def initialize(number)
    @number = number
    validate!
    @speed = 0
    @station_number = 0
    @cars = []
    @@all_trains.push(self)
    register_instance
  end

  def accelerate(speed)
    @speed = speed
  end

  def brake
    @speed = 0
  end

  def detach_car(car)
    @cars.delete(car) if @speed.zero?
  end

  def get_route(route)
    @route = route
    @station_number = 0
  end

  def move_forward
    if (@station_number + 1) >= @route.route_stations.size
      puts 'Нельзя переместить поезд дальше конечной станции'
    else
      @route.route_stations[station_number].send_train(self)
      @route.route_stations[station_number + 1].take_train(self)
      @station_number += 1
    end
  end

  def move_back
    if @station_number.zero?
      puts 'Нельзя переместить поезд дальше начальной станции'
    else
      @route.route_stations[station_number].send_train(self)
      @route.route_stations[station_number - 1].take_train(self)
      @station_number -= 1
    end
  end

  def previous_station
    @route.route_stations[@station_number - 1] if @station_number >= 1
  end

  def current_station
    @route.route_stations[@station_number]
  end

  def next_station
    @route.route_stations[@station_number + 1] if @station_number < @route.route_stations.size
  end

  def attach_car(car)
    @cars << car if @speed.zero? && (@type == car.type)
  end

  def block_cars
    cars.each do |car|
      yield(car)
    end
  end
end
