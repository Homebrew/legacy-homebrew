require 'formula'
require 'hardware'

class Mongodb < Formula
  homepage 'http://www.mongodb.org/'

  if ARGV.build_head?
    packages = {
      :x86_64 => {
        :url => 'http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-1.8.0-rc2.tgz',
        :md5 => 'b89e065fbc52f76bfe85e2e7bcc59f15',
        :version => '1.8.0-rc2-x86_64'
      },
      :i386 => {
        :url => 'http://fastdl.mongodb.org/osx/mongodb-osx-i386-1.8.0-rc2.tgz',
        :md5 => '0fa436dce2459c1d59beeb49c195d138',
        :version => '1.8.0-rc2-i386'
      }
    }
  else
    packages = {
      :x86_64 => {
        :url => 'http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-1.6.5.tgz',
        :md5 => 'f3438db5a5bd3ac4571616f3d19caf00',
        :version => '1.6.5-x86_64'
      },
      :i386 => {
        :url => 'http://fastdl.mongodb.org/osx/mongodb-osx-i386-1.6.5.tgz',
        :md5 => '064c9c68752968875e4ccaf8801ef031',
        :version => '1.6.5-i386'
      }
    }
  end

  package = (Hardware.is_64_bit? and not ARGV.include? '--32bit') ? packages[:x86_64] : packages[:i386]

  url     package[:url]
  md5     package[:md5]
  version package[:version]

  skip_clean :all

  def options
    [['--32bit', 'Override arch detection and install the 32-bit version.']]
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
  end

  def caveats; <<-EOS.undent
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
    EOS
  end

  def mongodb_conf
    return <<-EOS
# Store data in #{var}/mongodb instead of the default /data/db
dbpath = #{var}/mongodb

# Only accept local connections
bind_ip = 127.0.0.1
EOS
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
    <string>#{prefix}/mongod.conf</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
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
