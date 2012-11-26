require 'formula'

class SixtyFourBitRequired < Requirement
  def satisfied?
    MacOS.prefer_64_bit?
  end

  def fatal?; true end

  def message; <<-EOS.undent
    32-bit MongoDB binaries are no longer available.

    If you need to run a 32-bit version of MongoDB, you can
    compile the server from source:
      http://www.mongodb.org/display/DOCS/Building+for+OS+X
    EOS
  end
end

class Mongodb < Formula
  homepage 'http://www.mongodb.org/'
  url 'http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.2.1.tgz'
  sha1 '6fc3054cdc7f7e64b12742f7e8f9df256a3253d9'
  version '2.2.1-x86_64'

  devel do
    url 'http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.3.0.tgz'
    sha1 '816ca175bd31e2ec1eb8b61793b1d1e4a247a5da'
    version '2.3.0-x86_64'
  end

  depends_on SixtyFourBitRequired.new

  def install
    # Copy the prebuilt binaries to prefix
    prefix.install Dir['*']

    # Create the data and log directories under /var
    (var+'mongodb').mkpath
    (var+'log/mongodb').mkpath

    # Write the configuration files
    (prefix+'mongod.conf').write mongodb_conf

    # Homebrew: it just works.
    # NOTE plist updated to use prefix/mongodb!
    mv bin/'mongod', prefix
    (bin/'mongod').write <<-EOS.undent
      #!/usr/bin/env ruby
      ARGV << '--config' << '#{etc}/mongod.conf' unless ARGV.find { |arg| arg =~ /\-\-config/ }
      exec "#{prefix}/mongod", *ARGV
    EOS

    # copy the config file to etc if this is the first install.
    etc.install prefix+'mongod.conf' unless File.exists? etc+"mongod.conf"
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

  plist_options :manual => "mongod"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_prefix}/mongod</string>
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
