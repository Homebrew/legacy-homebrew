class Rethinkdb < Formula
  desc "The open-source database for the realtime web"
  homepage "http://www.rethinkdb.com/"
  url "http://download.rethinkdb.com/dist/rethinkdb-2.1.2.tgz"
  sha256 "e46495ccd95e8b2bd855211f48ecd6964a64b520b951115d46b9b9e55cb48322"

  bottle do
    cellar :any
    sha256 "b743e910f6ee34f7f4f10091eef7c0811ff16e780ae9931d8d604c4231b9260f" => :yosemite
    sha256 "7c5cc05fe50a92fbb0364bc55312ce93af605f9ca338d7cd82c39aef74badcfe" => :mavericks
    sha256 "0db293238d66b1049360f84c1b56ada3ff16312b1c404075c9fb8ba21abdc5ec" => :mountain_lion
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
