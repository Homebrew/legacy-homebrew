require "fileutils"
require "open-uri"

module Homebrew
  def autoupdate

    path = File.expand_path("~/Library/LaunchAgents/homebrew.mxcl.autoupdate.plist")

    if ARGV.empty?
      puts <<-EOS.undent
        Usage:
        --start = Start autoupdating every 24 hours.
        --stop = Stop autoupdating, but retain plist & logs.
        --delete = Cancel the autoupdate, delete the plist and logs.
      EOS
    end

    if ARGV.include? "--start"
      file = <<-EOS.undent
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>homebrew.mxcl.autoupdate</string>
          <key>ProgramArguments</key>
          <array>
              <string>/bin/sh</string>
              <string>-c</string>
              <string>/bin/date && #{HOMEBREW_PREFIX}/bin/brew update && #{HOMEBREW_PREFIX}/bin/brew upgrade -v</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>StandardErrorPath</key>
          <string>#{HOMEBREW_PREFIX}/var/log/homebrew.mxcl.autoupdate.err</string>
          <key>StandardOutPath</key>
          <string>#{HOMEBREW_PREFIX}/var/log/homebrew.mxcl.autoupdate.out</string>
          <key>StartInterval</key>
          <integer>86400</integer>
        </dict>
        </plist>
      EOS

      File.open(path, "w") { |f| f << file }
      quiet_system "/bin/launchctl", "load", path
      puts "Homebrew will now automatically update every 24 hours, or on system boot."
    end

    if ARGV.include? "--stop"
      quiet_system "/bin/launchctl", "unload", path
      puts "Homebrew will no longer autoupdate."
    end

    if ARGV.include? "--delete"
      quiet_system "/bin/launchctl", "unload", path
      rm_f path
      rm_f "#{HOMEBREW_PREFIX}/var/log/homebrew.mxcl.autoupdate.err"
      rm_f "#{HOMEBREW_PREFIX}/var/log/homebrew.mxcl.autoupdate.out"
      puts "Homebrew will no longer autoupdate and the plist has been deleted."
    end
  end
end
