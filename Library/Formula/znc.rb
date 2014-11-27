require "formula"

class Znc < Formula
  homepage "http://wiki.znc.in/ZNC"
  url "http://znc.in/releases/archive/znc-1.4.tar.gz"
  sha1 "6dafcf12b15fdb95eac5b427c8507c1095e904b4"

  head do
    url "https://github.com/znc/znc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "openssl"
  end

  bottle do
    sha1 "b899a3090ce637a09a12c22d76d130a5108b5b42" => :mavericks
    sha1 "7b808554d026a795d2555b5c1a66419fab999689" => :mountain_lion
    sha1 "bc2c4a31596a72d501d70b9e7b21b09580f58da2" => :lion
  end

  option "enable-debug", "Compile ZNC with --enable-debug"

  depends_on "pkg-config" => :build

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-debug" if build.include? "enable-debug"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make install"
  end

  plist_options :manual => "znc --foreground"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{bin}/znc</string>
          <string>--foreground</string>
        </array>
        <key>StandardErrorPath</key>
        <string>#{var}/log/znc.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/znc.log</string>
        <key>RunAtLoad</key>
        <true/>
        <key>StartInterval</key>
        <integer>300</integer>
      </dict>
    </plist>
    EOS
  end
end
