require "formula"

class Mongodb < Formula
  homepage "https://www.mongodb.org/"
  revision 1

  stable do
    url "https://fastdl.mongodb.org/src/mongodb-src-r2.6.4.tar.gz"
    sha1 "16dda6d8b1156194fc09b5ad72e58612d06abada"

    # Review this patch with the next stable release.
    # Note it is a different patch to the one applied to all builds further below.
    # This is already fixed in the devel & HEAD builds.
    if MacOS.version == :yosemite
      patch do
        url "https://github.com/mongodb/mongo/commit/759b6e8cabfb745b712b5ffd0748561129c3b421.diff"
        sha1 "63d901ac81681fbe8b92dc918954b247990ab2fb"
      end
    end
  end

  bottle do
    revision 1
    sha1 "f0d3195b48bbfa726f7c263a841610f5e96d3527" => :mavericks
    sha1 "d4cb743f2d8bd7c72846f361199e5e6021724d9f" => :mountain_lion
    sha1 "d03344c6d6bea73d8480af83b32f0337d35df5d9" => :lion
  end

  devel do
    url "https://fastdl.mongodb.org/src/mongodb-src-r2.7.7.tar.gz"
    sha1 "ce223f5793bdf5b3e1420b0ede2f2403e9f94e5a"

    # Remove this with the next devel release. Already merged in HEAD.
    # https://github.com/mongodb/mongo/commit/8b8e90fbe6bf97990f6997a576acfa2828867bec
    patch do
      url "https://github.com/mongodb/mongo/commit/8b8e90fbe6bf97990f6997a576acfa2828867bec.diff"
      sha1 "9f9ce609c7692930976690cae68aa4fce1f8bca3"
    end
  end

  # HEAD is currently failing. See https://jira.mongodb.org/browse/SERVER-15555
  head "https://github.com/mongodb/mongo.git"

  option "with-boost", "Compile using installed boost, not the version shipped with mongodb"

  depends_on "boost" => :optional
  depends_on :macos => :snow_leopard
  depends_on "scons" => :build
  depends_on "openssl" => :optional

  # Review this patch with each release.
  # This modifies the SConstruct file to include 10.10 as an accepted build option.
  if MacOS.version == :yosemite
    patch do
      url "https://raw.githubusercontent.com/DomT4/scripts/fbc0cdaea9e62cebc7e8e6948fe23d7873104523/Homebrew_Resources/Mongodb/mongoyosemite.diff"
      sha1 "f4824e93962154aad375eb29527b3137d07f358c"
    end
  end

  def install
    args = %W[
      --prefix=#{prefix}
      -j#{ENV.make_jobs}
      --cc=#{ENV.cc}
      --cxx=#{ENV.cxx}
      --osx-version-min=#{MacOS.version}
    ]

    # --full installs development headers and client library, not just binaries
    # (only supported pre-2.7)
    args << "--full" if build.stable?
    args << "--use-system-boost" if build.with? "boost"
    args << "--64" if MacOS.prefer_64_bit?

    if build.with? "openssl"
      args << "--ssl" << "--extrapath=#{Formula["openssl"].opt_prefix}"
    end

    scons "install", *args

    (buildpath+"mongod.conf").write mongodb_conf
    etc.install "mongod.conf"

    (var+"mongodb").mkpath
    (var+"log/mongodb").mkpath
  end

  def mongodb_conf; <<-EOS.undent
    systemLog:
      destination: file
      path: #{var}/log/mongodb/mongo.log
      logAppend: true
    storage:
      dbPath: #{var}/mongodb
    net:
      bindIp: 127.0.0.1
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
    system "#{bin}/mongod", "--sysinfo"
  end
end
