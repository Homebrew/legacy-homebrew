require 'formula'

class SixtyFourBitRequired < Requirement
  fatal true

  satisfy MacOS.prefer_64_bit?

<<<<<<< HEAD
  if Hardware.is_64_bit? and not build.build_32_bit?
<<<<<<< HEAD
    url 'http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.0.7.tgz'
    md5 '81b0e8be3206cc60e8031dde302fb983'
    version '2.0.7-x86_64'

    devel do
<<<<<<< HEAD
      url 'http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.2.0-rc0.tgz'
      md5 '49918bd6c5c5e84c4f657df35de6512b'
      version '2.2.0-rc0-x86_64'
=======
      url 'http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.2.0-rc2.tgz'
      md5 'a057c7987d7bc7ff6ced1b565a0856d1'
      version '2.2.0-rc2-x86_64'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
    end
  else
    url 'http://fastdl.mongodb.org/osx/mongodb-osx-i386-2.0.7.tgz'
    md5 '5fee3796ebc4e8721d9784ad8978b2b6'
    version '2.0.7-i386'

    devel do
<<<<<<< HEAD
      url 'http://fastdl.mongodb.org/osx/mongodb-osx-i386-2.2.0-rc0.tgz'
      md5 '236330754716334a6a9b88ff9bbcc3ea'
      version '2.2.0-rc0-i386'
=======
      url 'http://fastdl.mongodb.org/osx/mongodb-osx-i386-2.2.0-rc2.tgz'
      md5 '5426d47cd2718814c07152b34d0ea18d'
      version '2.2.0-rc2-i386'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
    end
=======
    url 'http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.2.0.tgz'
    md5 '5ad0d0b046919118e73976d670dce5e5'
    version '2.2.0-x86_64'
  else
    url 'http://fastdl.mongodb.org/osx/mongodb-osx-i386-2.2.0.tgz'
    md5 '59a59df34922f3caaa6219ab8ebf05dd'
    version '2.2.0-i386'
>>>>>>> 82a1481f6fa824816bbf2bdeb53fd1933a1a15f2
=======
  def message; <<-EOS.undent
    32-bit MongoDB binaries are no longer available.

    If you need to run a 32-bit version of MongoDB, you can
    compile the server from source:
      http://www.mongodb.org/display/DOCS/Building+for+OS+X
    EOS
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40
  end
end

class Mongodb < Formula
  homepage 'http://www.mongodb.org/'
  url 'http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.2.3.tgz'
  sha1 '6b81469374eb8d1b209fcdd8111d4e654573d095'
  version '2.2.3-x86_64'

  devel do
    url 'http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.4.0-rc0.tgz'
    sha1 '0c6bcabbf914436d265e16f2ca0cd49b63888e19'
    version '2.4.0-rc0-x86_64'
  end

  depends_on SixtyFourBitRequired

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
      <key>HardResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>1024</integer>
      </dict>
      <key>SoftResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>1024</integer>
      </dict>
    </dict>
    </plist>
    EOS
  end
end
