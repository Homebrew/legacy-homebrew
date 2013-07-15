class Formula
  def fails_with_llvm msg=nil, data=nil
    opoo "Calling fails_with_llvm in the install method is deprecated"
    puts "Use the fails_with DSL instead"
  end

  def fails_with_llvm?
    fails_with? :llvm
  end

  def self.fails_with_llvm msg=nil, data={}
    case msg when Hash then data = msg end
    failure = CompilerFailure.new(:llvm) { build(data.delete(:build).to_i) }
    @cc_failures ||= Set.new
    @cc_failures << failure
  end
end
