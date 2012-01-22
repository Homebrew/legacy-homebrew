require 'formula'
require 'hardware'

class Mongodb < Formula
  homepage 'http://www.mongodb.org/'

  packages = {
    :x86_64 => {
      :url => 'http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.0.2.tgz',
      :md5 => '65d9df2b1e8d2bf2c9aef30e35d1d9f0',
      :version => '2.0.2-x86_64'
    },
    :i386 => {
      :url => 'http://fastdl.mongodb.org/osx/mongodb-osx-i386-2.0.2.tgz',
      :md5 => '5eba72d2e348618cf4a905bba1bd9bb6',
      :version => '2.0.2-i386'
    }
  }

  package = (Hardware.is_64_bit? and not ARGV.build_32_bit?) ? packages[:x86_64] : packages[:i386]

  url     package[:url]
  md5     package[:md5]
  version package[:version]

  skip_clean :all

  def options
    [
        ['--32-bit', 'Build 32-bit only.'],
        ['--nojournal', 'Disable write-ahead logging (Journaling)'],
        ['--rest', 'Enable the REST Interface on the HTTP Status Page'],
    ]
  end

  def install
    # Copy the prebuilt binaries to prefix
    prefix.install Dir['*']

    # Create the data and log directories under /var
    (var+'mongodb').mkpath
    (var+'log/mongodb').mkpath

    # Write the configuration files and launchd script
    (prefix+'mongod.conf').write mongodb_conf
    (prefix+'org.mongodb.mongod.plist').write startup_plist
    (prefix+'org.mongodb.mongod.plist').chmod 0644
  end

  def caveats
    s = ""
    s += <<-EOS.undent
    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/org.mongodb.mongod.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.mongodb.mongod.plist

    If this is an upgrade and you already have the org.mongodb.mongod.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/org.mongodb.mongod.plist
        cp #{prefix}/org.mongodb.mongod.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.mongodb.mongod.plist

    Or start it manually:
        mongod run --config #{prefix}/mongod.conf

    The launchctl plist above expects the config file to be at #{etc}/mongod.conf.
    If this is a first install, you can copy one from #{prefix}/mongod.conf:
        cp #{prefix}/mongod.conf #{etc}/mongod.conf
    EOS

    if ARGV.include? "--nojournal"
        s += "\n"
        s += <<-EOS.undent
        Write Ahead logging (Journaling) has been disabled.
        EOS
    else
        s += "\n"
        s += <<-EOS.undent
        MongoDB 1.8+ includes a feature for Write Ahead Logging (Journaling), which has been enabled by default.
        To disable journaling, use --nojournal.
        EOS
    end

    return s
  end

  def mongodb_conf
    conf = ""
    conf += <<-EOS.undent
    # Store data in #{var}/mongodb instead of the default /data/db
    dbpath = #{var}/mongodb

    # Only accept local connections
    bind_ip = 127.0.0.1
    EOS

    if ARGV.include? '--nojournal'
      conf += <<-EOS.undent
      # Disable Write Ahead Logging
      nojournal = true
      EOS
    end

    if ARGV.include? '--rest'
        conf += <<-EOS.undent
        # Enable the REST interface on the HTTP Console (startup port + 1000)
        rest = true
        EOS
    end

    return conf
  end

  def startup_plist
    return <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>org.mongodb.mongod</string>
  <key>ProgramArguments</key>
  <array>
    <string>#{bin}/mongod</string>
    <string>run</string>
    <string>--config</string>
    <string>#{etc}/mongod.conf</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <false/>
  <key>UserName</key>
  <string>#{`whoami`.chomp}</string>
  <key>WorkingDirectory</key>
  <string>#{HOMEBREW_PREFIX}</string>
  <key>StandardErrorPath</key>
  <string>#{var}/log/mongodb/output.log</string>
  <key>StandardOutPath</key>
  <string>#{var}/log/mongodb/output.log</string>
</dict>
</plist>
EOS
  end
end
