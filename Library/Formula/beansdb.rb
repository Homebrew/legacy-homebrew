require "formula"

class Beansdb < Formula
  homepage "https://github.com/douban/beansdb"
  url "https://github.com/douban/beansdb/archive/v0.6.tar.gz"
  sha1 "9099ce607ff3c3eba251ee34ae65a08c4e3715b9"

  head do
    url "https://github.com/douban/beansdb.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    (var/"db/beansdb").mkpath
    (var/"log").mkpath
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <dict>
        <key>SuccessfulExit</key>
        <false/>
      </dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/beansdb</string>
        <string>-p</string>
        <string>7900</string>
        <string>-H</string>
        <string>#{var}/db/beansdb</string>
        <string>-T</string>
        <string>1</string>
        <string>-vv</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/beansdb.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/beansdb.log</string>
    </dict>
    </plist>
    EOS
  end
end
