class Station
  require_relative 'instance_counter'
  require_relative 'validation'

  include InstanceCounter
  include Validation

  validate :name, :presence

  @@all_stations = []

  def self.all
    @@all_stations
  end

  attr_reader :trains, :name

  def initialize(name)
    @name = name
    validate!
    @trains = []
    @@all_stations.push(self)
    register_instance
  end

  def take_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def trains_by_class(car_class = nil)
    if car_class.nil?
      @trains
    else
      @trains.find_all { |tr| tr.instance_of?(car_class) }
    end
  end

  def block_stations
    @trains.each do |train|
      yield(train)
    end
  end
end
