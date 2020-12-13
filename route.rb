class Route
  attr_reader :route_stations, :start_station

  require_relative 'instance_counter'
  require_relative 'station'
  require_relative 'validation'

  include InstanceCounter
  include Validation

  validate :start_station, :type, Station

  def initialize(start_station, end_station)
    @route_stations = [start_station, end_station]
    register_instance
  end

  def add_intermediate_station(station)
    @route_stations.insert(1, station)
  end

  def exclude_intermediate_station(station)
    @route_stations.delete_at(station)
  end
end
