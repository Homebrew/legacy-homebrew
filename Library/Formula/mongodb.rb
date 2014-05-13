require 'formula'

class Mongodb < Formula
  homepage "http://www.mongodb.org/"
  url "http://downloads.mongodb.org/src/mongodb-src-r2.6.1.tar.gz"
  sha1 "3e069329e93a45f14bb86618eceea08d376dbc82"

  bottle do
    sha1 "091cafed1db9c96b4487a806f61df8ba0c3523b4" => :mavericks
    sha1 "3a91d1ed6e1e75f48e6fc241a0cc3fba9d8aa810" => :mountain_lion
    sha1 "3ffe58f9e71dfd0700e08651f272f7a511dbb8d2" => :lion
  end

  devel do
     url "http://downloads.mongodb.org/src/mongodb-src-r2.7.0.tar.gz"
     sha1 "43449a69c3386e13fdb6abb2b13933f3ba607cc5"
  end

  head do
    url "https://github.com/mongodb/mongo.git"
  end

  option "with-boost", "Compile using installed boost, not the version shipped with mongodb"
  depends_on "boost" => :optional

  depends_on "scons" => :build
  depends_on "openssl" => :optional

  def install
    args = ["--prefix=#{prefix}", "-j#{ENV.make_jobs}"]

    cxx = ENV.cxx
    if ENV.compiler == :clang && MacOS.version >= :mavericks
      # when building on Mavericks with libc++
      # Use --osx-version-min=10.9 such that the compiler defaults to libc++.
      # Upstream issue discussing the default flags:
      # https://jira.mongodb.org/browse/SERVER-12682
      args << "--osx-version-min=10.9"
    end

    args << '--64' if MacOS.prefer_64_bit?
    args << "--cc=#{ENV.cc}"
    args << "--cxx=#{cxx}"

    # --full installs development headers and client library, not just binaries
    # (only supported pre-2.7)
    args << "--full" if build.stable?
    args << "--use-system-boost" if build.with? "boost"

    if build.with? 'openssl'
      args << '--ssl'
      args << "--extrapath=#{Formula["openssl"].opt_prefix}"
    end

    scons 'install', *args

    (buildpath+"mongod.conf").write mongodb_conf
    etc.install "mongod.conf"

    (var+'mongodb').mkpath
    (var+'log/mongodb').mkpath
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

  plist_options :manual => "mongod --config #{HOMEBREW_PREFIX}/etc/mongod.conf"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/mongod</string>
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

  test do
    system "#{bin}/mongod", '--sysinfo'
  end
end
