module OS
  def self.mac?
    /darwin/i === RUBY_PLATFORM
  end

  def self.linux?
    /linux/i === RUBY_PLATFORM
  end

  if OS.mac?
    GITHUB_REPOSITORY = "homebrew"
    PATH_OPEN = "/usr/bin/open"
  elsif OS.linux?
    GITHUB_REPOSITORY = "linuxbrew"
    PATH_OPEN = "xdg-open"
  else
    raise "Unknown operating system"
  end
  ISSUES_URL = "https://github.com/Homebrew/#{GITHUB_REPOSITORY}/blob/master/share/doc/homebrew/Troubleshooting.md#troubleshooting"
end
