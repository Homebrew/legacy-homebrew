require 'continuation' if RUBY_VERSION.to_f >= 1.9

class Exception
  attr_accessor :continuation

  def restart(&block)
    continuation.call block
  end
end

module RaisePlus
  alias :original_raise :raise

  private

  def raise(*args)
    exception = case
                when args.size == 0
                  $!.nil? ? RuntimeError.exception : $!
                when args.size == 1 && args[0].is_a?(String)
                  RuntimeError.exception(args[0])
                when args.size == 2 && args[0].is_a?(Exception)
                  args[0].exception(args[1])
                when args[0].is_a?(Class) && args[0].ancestors.include?(Exception)
                  args[0].exception(args[1])
                else
                  args[0]
                end

    # passing something other than a String or Exception is illegal, but if someone does it anyway,
    # that object won't have backtrace or continuation methods. in that case, let's pass it on to
    # the original raise, which will reject it
    return super exception unless exception.is_a?(Exception)

    # keep original backtrace if reraising
    exception.set_backtrace(args.size >= 3 ? args[2] : caller) if exception.backtrace.nil?

    blk = callcc do |cc|
      exception.continuation = cc
      super exception
    end
    blk.call unless blk.nil?
  end

  alias :fail :raise
end
