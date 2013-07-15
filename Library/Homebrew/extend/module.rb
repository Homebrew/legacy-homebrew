class Module
  def attr_rw(*attrs)
    attrs.each do |attr|
      module_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{attr}(val=nil)
          val.nil? ? @#{attr} : @#{attr} = val
        end
      EOS
    end
  end
end
