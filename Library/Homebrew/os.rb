module OS
  def self.mac?
    /darwin/i === RUBY_PLATFORM
  end

  def self.linux?
    /linux/i === RUBY_PLATFORM
  end

  if OS.mac?
    GITHUB_REPOSITORY = "homebrew"
    ISSUES_URL = "https://git.io/brew-troubleshooting"
    PATH_OPEN = "/usr/bin/open"
    PATH_PATCH = "/usr/bin/patch"
  elsif OS.linux?
    GITHUB_REPOSITORY = "linuxbrew"
    ISSUES_URL = "https://github.com/Homebrew/#{GITHUB_REPOSITORY}/blob/master/share/doc/homebrew/Troubleshooting.md#troubleshooting"
    PATH_OPEN = "xdg-open"
    PATH_PATCH = "patch"
  else
    raise "Unknown operating system"
  end
end
