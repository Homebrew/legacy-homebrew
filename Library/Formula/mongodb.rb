require 'formula'

class Mongodb < Formula
  homepage 'http://www.mongodb.org/'
  url 'http://downloads.mongodb.org/src/mongodb-src-r2.4.6.tar.gz'
  sha1 '32066d405f3bed175c9433dc4ac455c2e0091b53'

  devel do
    url 'http://downloads.mongodb.org/src/mongodb-src-r2.5.2.tar.gz'
    sha1 'e6b0aa35ea78e6bf9d7791a04810a4db4d69decc'
  end

  head 'https://github.com/mongodb/mongo.git'

  bottle do
    sha1 'ddac997b68deff5bfa04d22f5ddef44f895e6629' => :mountain_lion
    sha1 '85ed3769ab3bc301dd044c94522fea24fb91d16f' => :lion
    sha1 '2e5a28f2a9c97058b5e3b002403ed2fb3439cd8c' => :snow_leopard
  end

  depends_on 'scons' => :build
  depends_on 'openssl' => :optional

  def install
    args = ["--prefix=#{prefix}", "-j#{ENV.make_jobs}"]
    args << '--64' if MacOS.prefer_64_bit?

    if build.with? 'openssl'
      args << '--ssl'
      args << "--extrapathdyn=#{Formula.factory('openssl').opt_prefix}"
    end

    system 'scons', 'install', *args

    (var+'mongodb').mkpath
    (var+'log/mongodb').mkpath

    (prefix+'mongod.conf').write mongodb_conf

    mv bin/'mongod', prefix
    (bin/'mongod').write <<-EOS.undent
      #!/usr/bin/env ruby
      ARGV << '--config' << '#{etc}/mongod.conf' unless ARGV.find { |arg|
        arg =~ /^\s*\-\-config$/ or arg =~ /^\s*\-f$/
      }
      exec "#{prefix}/mongod", *ARGV
    EOS

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
