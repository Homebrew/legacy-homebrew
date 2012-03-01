module HTTParty
  module ModuleInheritableAttributes #:nodoc:
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods #:nodoc:
      def mattr_inheritable(*args)
        @mattr_inheritable_attrs ||= [:mattr_inheritable_attrs]
        @mattr_inheritable_attrs += args
        args.each do |arg|
          module_eval %(class << self; attr_accessor :#{arg} end)
        end
        @mattr_inheritable_attrs
      end

      def inherited(subclass)
        super
        @mattr_inheritable_attrs.each do |inheritable_attribute|
          ivar = "@#{inheritable_attribute}"
          subclass.instance_variable_set(ivar, instance_variable_get(ivar).clone)
          if instance_variable_get(ivar).respond_to?(:merge)
            method = <<-EOM
              def self.#{inheritable_attribute}
                #{ivar} = superclass.#{inheritable_attribute}.merge #{ivar}
              end
            EOM
            subclass.class_eval method
          end
        end
      end
    end
  end
end
