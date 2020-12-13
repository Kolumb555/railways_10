require_relative 'train'

require_relative 'validation'
include Validation

class PassengerTrain < Train
  attr_reader :type

  def initialize(number)
    @number = number
    @type = 'passenger'
    super
  end
end
