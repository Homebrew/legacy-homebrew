module OS
  def self.mac?
    /darwin/i === RUBY_PLATFORM
  end

  def self.linux?
    /linux/i === RUBY_PLATFORM
  end

  if OS.mac?
    ISSUES_URL = "https://github.com/Homebrew/homebrew/wiki/troubleshooting"
    PATH_OPEN = "/usr/bin/open"
  elsif OS.linux?
    ISSUES_URL = "https://github.com/Homebrew/linuxbrew/wiki/troubleshooting"
    PATH_OPEN = "xdg-open"
  else
    raise "Unknown operating system"
  end
end
