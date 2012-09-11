require 'formula'

class Mongodb < Formula
  homepage 'http://www.mongodb.org/'

  if Hardware.is_64_bit? and not build.build_32_bit?
    url 'http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.2.0.tgz'
    md5 '5ad0d0b046919118e73976d670dce5e5'
    version '2.2.0-x86_64'
  else
    url 'http://fastdl.mongodb.org/osx/mongodb-osx-i386-2.2.0.tgz'
    md5 '59a59df34922f3caaa6219ab8ebf05dd'
    version '2.2.0-i386'
  end

  option '32-bit'

  def install
    # Copy the prebuilt binaries to prefix
    prefix.install Dir['*']

    # Create the data and log directories under /var
    (var+'mongodb').mkpath
    (var+'log/mongodb').mkpath

    # Write the configuration files
    (prefix+'mongod.conf').write mongodb_conf

    # Homebrew: it just works.
    mv (sh = bin/'mongod'), prefix
    sh.write <<-EOS.undent
      #!/usr/bin/env ruby
      ARGV << '--config' << '#{etc}/mongod.conf' unless ARGV.include? '--config'
      exec "#{prefix}/mongod", *ARGV
    EOS
    sh.chmod 0755

    # copy the config file to etc if this is the first install.
    etc.install prefix+'mongod.conf' unless File.exists? etc+"mongod.conf"
  end

  def caveats
    bn = plist_path.basename
    plist_path = "#{HOMEBREW_PREFIX}/opt/#{name}/*.plist"
    <<-EOS.undent
    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        ln -s #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{bn}

    If this is an upgrade and you already have the plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/#{bn}
        launchctl load -w ~/Library/LaunchAgents/#{bn}

    Or just start it manually:
        mongod
    EOS
  end

  def mongodb_conf; <<-EOS.undent
    # Store data in #{var}/mongodb instead of the default /data/db
    dbpath = #{var}/mongodb

    # Append logs to #{var}/log/mongodb/mongo.log
    logpath = #{var}/log/mongodb/mongo.log
    logappend = true

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
  <string>#{plist_name}</string>
  <key>ProgramArguments</key>
  <array>
    <string>#{HOMEBREW_PREFIX}/bin/mongod</string>
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
