class Symbol
  def to_proc
    proc { |*args| args.shift.send(self, *args) }
  end unless method_defined?(:to_proc)
end
