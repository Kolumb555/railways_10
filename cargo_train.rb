require_relative 'train'
require_relative 'validation'
include Validation

class CargoTrain < Train
  attr_reader :type

  def initialize(number)
    @number = number
    @type = 'cargo'
    super
  end
end
