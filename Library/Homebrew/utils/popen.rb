module Utils
  def self.popen_read(*args, &block)
    popen(args, "rb", &block)
  end

  def self.popen_write(*args, &block)
    popen(args, "wb", &block)
  end

  def self.popen(args, mode)
    IO.popen("-", mode) do |pipe|
      if pipe
        if block_given?
          yield pipe
        else
          return pipe.read
        end
      else
        STDERR.reopen("/dev/null", "w")
        exec(*args)
      end
    end
  end
end
