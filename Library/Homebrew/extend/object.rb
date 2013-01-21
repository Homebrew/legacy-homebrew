class Object
  def instance_exec(*args, &block)
    method_name = :__temp_instance_exec_method
    singleton_class = (class << self; self; end)
    singleton_class.class_eval do
      define_method(method_name, &block)
    end

    send(method_name, *args)
  ensure
    singleton_class.class_eval do
      remove_method(method_name) if method_defined?(method_name)
    end
  end unless method_defined?(:instance_exec)
end
