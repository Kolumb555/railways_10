module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(_attr_name, type, *args)
      @validations ||= []
      @validations << { attr_name: name, type: type, args: args }
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |validation|
        attr_name = instance_variable_get("@#{validations[:attr_name]}")
        send((validation[:type]).to_s, attr_name, *validation[args])
      end
    end

    def presence(attr_name)
      raise 'nil or empty string' if attr_name.to_s == ''
    end

    def format(attr_name, args)
      raise 'wrong format' if attr_name !~ args
    end

    def type(attr_name, args)
      raise 'wrong type' if attr_name.class != args
    end

    def valid?
      validate!
      true
    rescue RuntimeError
      false
    end
  end
end
