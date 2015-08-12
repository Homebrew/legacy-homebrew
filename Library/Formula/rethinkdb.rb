class Rethinkdb < Formula
  desc "The open-source database for the realtime web"
  homepage "http://www.rethinkdb.com/"
  url "http://download.rethinkdb.com/dist/rethinkdb-2.1.1.tgz"
  sha256 "1e273f4e3d1902f7ed9aebb147992713568eb2957f4f3af635f4ed63c43a3b49"

  bottle do
    cellar :any
    sha256 "481c050282429de7a9cddc66e63d0de8b7ceb8ca7ae0de1ad5b95959013ded88" => :yosemite
    sha256 "683167d92a98d1bbfc0eca8c048a6a33453e24a46a4188bf3ad4e3c6c1aed9e9" => :mavericks
    sha256 "f0b02cf673202dcfb7811453f89bcc535c753d64469f85485dff4ea9e7913347" => :mountain_lion
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
