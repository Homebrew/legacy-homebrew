module OS
  def self.mac?
    /darwin/i === RUBY_PLATFORM
  end

  def self.linux?
    /linux/i === RUBY_PLATFORM
  end

  # Utilities
  if OS.mac?
    PATH_OPEN = "/usr/bin/open"
  elsif OS.linux?
    PATH_OPEN = "xdg-open"
  else
    raise "Unknown operating system"
  end
end
