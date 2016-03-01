class Transmission < Formula
  desc "Lightweight BitTorrent client"
  homepage "http://www.transmissionbt.com/"
  url "https://transmission.cachefly.net/transmission-2.90.tar.xz"
  sha256 "69ff8caf81684155926f437f46bf7df1b1fb304f52c7809f546257e8923f2fd2"

  bottle do
    sha256 "851b3c1e6428ffb1faf9a27254583fd74d0c562a3a4f28526fd0c87acc2cbb04" => :el_capitan
    sha256 "b70dde06f3acdd077ed4853198bc648a01975bb3a8e8784e2e34502e3e550576" => :yosemite
    sha256 "75df41ea299b772c9dd5ff1379730d9fea9c735be68a46da9b95b3e644423329" => :mavericks
  end

  option "with-nls", "Build with native language support"

  depends_on "pkg-config" => :build
  depends_on "curl" if MacOS.version <= :leopard
  depends_on "libevent"

  if build.with? "nls"
    depends_on "intltool" => :build
    depends_on "gettext"
  end

  def install
    ENV.append "LDFLAGS", "-framework Foundation -prebind"
    ENV.append "LDFLAGS", "-liconv"

    args = %W[--disable-dependency-tracking
              --prefix=#{prefix}
              --disable-mac
              --without-gtk]

    args << "--disable-nls" if build.without? "nls"

    system "./configure", *args
    system "make", "install"

    (var/"transmission").mkpath
  end

  def caveats; <<-EOS.undent
    This formula only installs the command line utilities.
    Transmission.app can be downloaded from Transmission's website:
      http://www.transmissionbt.com
    EOS
  end

  plist_options :manual => "transmission-daemon --foreground"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/transmission-daemon</string>
          <string>--foreground</string>
          <string>--config-dir</string>
          <string>#{var}/transmission/</string>
          <string>--log-info</string>
          <string>--logfile</string>
          <string>#{var}/transmission/transmission-daemon.log</string>
        </array>
        <key>KeepAlive</key>
        <dict>
          <key>NetworkState</key>
          <true/>
        </dict>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/transmission-create", "-o", "#{testpath}/test.mp3.torrent", test_fixtures("test.mp3")
    assert_match /^magnet:/, shell_output("#{bin}/transmission-show -m #{testpath}/test.mp3.torrent")
  end
end
