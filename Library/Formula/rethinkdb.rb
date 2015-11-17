class Rethinkdb < Formula
  desc "The open-source database for the realtime web"
  homepage "https://www.rethinkdb.com/"
  url "https://download.rethinkdb.com/dist/rethinkdb-2.2.1.tgz"
  sha256 "6611b4e62020a68c23e0a1f0a517b97677e0358c261a3e188d14b02b014a2c9e"

  bottle do
    cellar :any
    sha256 "6258c8d65ecadf89ed7ce11259ddd3e700ee7ad9bb51dfbf742d7bd686119320" => :el_capitan
    sha256 "9c9e77fe00e25ba430c8550a418ecebd9e2cb366e135b42ec5218c206ece59ee" => :yosemite
    sha256 "5ae5ebd460bf8a7bdd2d4a77d00f6a20721133c48985651162d573fc20a29a99" => :mavericks
  end

  depends_on :macos => :lion
  depends_on "boost" => :build
  depends_on "openssl"

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

    (var/"log/rethinkdb").mkpath
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
