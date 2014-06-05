module OS
  def self.mac?
    /darwin/i === RUBY_PLATFORM
  end

  def self.linux?
    /linux/i === RUBY_PLATFORM
  end
end

if OS.mac?
  require "os/mac/bottles"
elsif OS.linux?
  require "os/linux/bottles"
end
