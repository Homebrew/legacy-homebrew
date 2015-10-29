module OS
  def self.mac?
    /darwin/i === RUBY_PLATFORM
  end

  def self.linux?
    /linux/i === RUBY_PLATFORM
  end

  if OS.mac?
    require "os/mac"
    ISSUES_URL = "https://git.io/brew-troubleshooting"
    PATH_OPEN = "/usr/bin/open"
    # compatibility
    ::MACOS_FULL_VERSION = OS::Mac.full_version.to_s
    ::MACOS_VERSION = OS::Mac.version.to_s
    ::OS_VERSION = "OS X #{MACOS_FULL_VERSION}"
  elsif OS.linux?
    ISSUES_URL = "https://github.com/Homebrew/linuxbrew/wiki/troubleshooting"
    PATH_OPEN = "xdg-open"
    # compatibility
    ::MACOS_FULL_VERSION = ::MACOS_VERSION = "0"
    ::OS_VERSION = RUBY_PLATFORM
  else
    raise "Unknown operating system"
  end
end
