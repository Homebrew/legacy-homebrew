class Rethinkdb < Formula
  homepage "http://www.rethinkdb.com/"
  url "http://download.rethinkdb.com/dist/rethinkdb-1.16.2-1.tgz"
  version "1.16.2-1"
  sha1 "17cf96e18ddd7a8e909c6d4339d45b32f186b7c0"

  bottle do
    sha1 "d0d5f83c19ff5b20b9adee82339c7cf0798f76f9" => :yosemite
    sha1 "6ce74cea321c3aa31f458d73d1a9c9576e3120e7" => :mavericks
    sha1 "412b9e0d0f27234ff3e4efc8802698d11a3e768f" => :mountain_lion
  end

  depends_on :macos => :lion
  # Embeds an older V8, whose gyp still requires the full Xcode
  # Reported upstream: https://github.com/rethinkdb/rethinkdb/issues/2581
  depends_on :xcode => :build
  depends_on "boost" => :build
  depends_on "openssl"

  fails_with :gcc do
    build 5666 # GCC 4.2.1
    cause "RethinkDB uses C++0x"
  end

  def install
    args = ["--prefix=#{prefix}"]

    # brew's v8 is too recent. rethinkdb uses an older v8 API
    args += ["--fetch", "v8"]

    # rethinkdb requires that protobuf be linked against libc++
    # but brew's protobuf is sometimes linked against libstdc++
    args += ["--fetch", "protobuf"]

    # support gcc with boost 1.56
    # https://github.com/rethinkdb/rethinkdb/issues/3044#issuecomment-55471981
    args << "CXXFLAGS=-DBOOST_VARIANT_DO_NOT_USE_VARIADIC_TEMPLATES"

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
