require "language/go"

class Mongodb < Formula
  homepage "https://www.mongodb.org/"

  stable do
    url "https://fastdl.mongodb.org/src/mongodb-src-r3.0.3.tar.gz"
    sha256 "57765a81c18a0bb674fbe63bc507111d8795596eb9c9492028903985b4720807"

    go_resource "github.com/mongodb/mongo-tools" do
      url "https://github.com/mongodb/mongo-tools.git",
        :tag => "r3.0.3",
        :revision => "13a7eac12d16edd41fa875df759b16e4b027db7f"
    end
  end

  devel do
    url "https://fastdl.mongodb.org/src/mongodb-src-r3.1.3.tar.gz"
    sha256 "edd3c7eabac765d4bf47efd38e22b3fc6271a77559f8173c5da9c38a43ec05df"

    go_resource "github.com/mongodb/mongo-tools" do
      url "https://github.com/mongodb/mongo-tools.git",
        :tag => "r3.1.3",
        :revision => "9aa74bcbecc3bd4d995dd14281e84ad33c119c70"
    end
  end

  bottle do
    cellar :any
    sha256 "11b56632d04d55ca9b84c2b3c5d84b71aaa4cd915871e3530f4a62f5e72666c1" => :yosemite
    sha256 "3b0c1f8d8b5d5f86e61cdc62cc20dd58316c56c110267d5d7fe439c821263d56" => :mavericks
    sha256 "3aa0133679f5ef2325403c6e4cd96bc3b48aad0ea529c33c497ae77823f7994f" => :mountain_lion
  end

  option "with-boost", "Compile using installed boost, not the version shipped with mongodb"

  depends_on "boost" => :optional
  depends_on "go" => :build
  depends_on :macos => :mountain_lion
  depends_on "scons" => :build
  depends_on "openssl" => :optional

  def install
    ENV.libcxx if build.devel?

    # New Go tools have their own build script but the server scons "install" target is still
    # responsible for installing them.
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/mongodb/mongo-tools" do
      # https://github.com/Homebrew/homebrew/issues/40136
      inreplace "build.sh", '-ldflags "-X github.com/mongodb/mongo-tools/common/options.Gitspec `git rev-parse HEAD`"', ""

      args = %W[]

      if build.with? "openssl"
        args << "ssl"
        ENV["LIBRARY_PATH"] = "#{Formula["openssl"].opt_prefix}/lib"
        ENV["CPATH"] = "#{Formula["openssl"].opt_prefix}/include"
      end
      system "./build.sh", *args
    end

    mkdir "src/mongo-tools"
    cp Dir["src/github.com/mongodb/mongo-tools/bin/*"], "src/mongo-tools/"

    args = %W[
      --prefix=#{prefix}
      -j#{ENV.make_jobs}
      --osx-version-min=#{MacOS.version}
    ]

    if build.stable?
      args << "--cc=#{ENV.cc}"
      args << "--cxx=#{ENV.cxx}"
    end

    if build.devel?
      args << "CC=#{ENV.cc}"
      args << "CXX=#{ENV.cxx}"
    end

    args << "--use-system-boost" if build.with? "boost"
    args << "--use-new-tools"

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
        <integer>4096</integer>
      </dict>
      <key>SoftResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>4096</integer>
      </dict>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/mongod", "--sysinfo"
  end
end
