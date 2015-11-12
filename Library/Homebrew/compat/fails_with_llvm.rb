class Formula
  def fails_with_llvm(_msg = nil, _data = nil)
    opoo "Calling fails_with_llvm in the install method is deprecated"
    puts "Use the fails_with DSL instead"
  end

  def self.fails_with_llvm(msg = nil, data = {})
    data = msg if Hash === msg
    fails_with(:llvm) { build(data.delete(:build).to_i) }
  end
end
