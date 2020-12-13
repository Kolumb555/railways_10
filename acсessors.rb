module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        name_history = "@#{name}_history".to_sym
        define_method(name) { instance_variable_get(var_name) }
        define_method("#{name}=".to_sym) do |v|
          instance_variable_set(var_name, v)
          if instance_variable_get(name_history).nil?
            instance_variable_set(name_history, [])
          else
            instance_variable_get(name_history) << instance_variable_get(var_name)
          end
        end
      end
    end
  end

  def strong_attr_accessor(name, arg_class)
    var_name = "@#{name}".to_sym
    define_method(name) { instance_variable_get(var_name) }
    define_method("#{name}=".to_sym) do |v|
      raise "the classes don't match" unless name.instance_of?(arg_class)

      instance_variable_set(var_name, v)
    end
  end
end
