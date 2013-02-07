class Exception
  attr_accessor :continuation

  def restart(&block)
    continuation.call block
  end
end
