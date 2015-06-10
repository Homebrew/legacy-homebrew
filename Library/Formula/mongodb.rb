require "language/go"

class Mongodb < Formula
  desc "High-performance, schema-free, document-oriented database"
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
    url "https://fastdl.mongodb.org/src/mongodb-src-r3.1.4.tar.gz"
    sha256 "76af6357fdffa007931c6c4f0929244da5e987c33dd2d670454830cefa2388a0"

    go_resource "github.com/mongodb/mongo-tools" do
      url "https://github.com/mongodb/mongo-tools.git",
        :tag => "r3.1.4",
        :revision => "102574bcf8fe267f2104ac24be68ec1c50fe63d6"
    end
  end

  bottle do
    cellar :any
    revision 1
    sha256 "f89334dc463941c478c36a82d527d09699a8957490b4fc9f66ec7ea49b1a70a3" => :yosemite
    sha256 "4772b547e272c087da3a3fc9a60350b4ce208187f830fdbbc91e6829508c04b3" => :mavericks
    sha256 "e6d995c3124effee093ccf6afaf0d0f5fbda3b76c37040174d3373a7f7ba91a8" => :mountain_lion
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
