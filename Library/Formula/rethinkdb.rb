class Rethinkdb < Formula
  desc "The open-source database for the realtime web"
  homepage "http://www.rethinkdb.com/"
  url "http://download.rethinkdb.com/dist/rethinkdb-2.1.2.tgz"
  sha256 "e46495ccd95e8b2bd855211f48ecd6964a64b520b951115d46b9b9e55cb48322"

  bottle do
    cellar :any
    sha256 "d23d74af5012291dc17baf43c52e160bac205993c382e4f7735e87b6629b5269" => :yosemite
    sha256 "ab004f3d794361d220718ab0784fbbe34960f9999f6801264459800934eb579d" => :mavericks
    sha256 "0d2fecbd99924316a5a98dd7e2e360645389f67533f6600efc5764d82108c992" => :mountain_lion
  end

  depends_on :macos => :lion
  depends_on "boost" => :build
  depends_on "openssl"
  depends_on "icu4c"

  fails_with :gcc do
    build 5666 # GCC 4.2.1
    cause "RethinkDB uses C++0x"
  end

  def install
    args = ["--prefix=#{prefix}"]

    # rethinkdb requires that protobuf be linked against libc++
    # but brew's protobuf is sometimes linked against libstdc++
    args += ["--fetch", "protobuf"]

    system "./configure", *args
    system "make"
    system "make", "install-osx"

    mkdir_p "#{var}/log/rethinkdb"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
          <string>#{opt_bin}/rethinkdb</string>
          <string>-d</string>
          <string>#{var}/rethinkdb</string>
      </array>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/rethinkdb/rethinkdb.log</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/rethinkdb/rethinkdb.log</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    shell_output("#{bin}/rethinkdb create -d test")
    assert File.read("test/metadata").start_with?("RethinkDB")
  end
end
