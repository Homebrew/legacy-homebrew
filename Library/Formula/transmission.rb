class Transmission < Formula
  desc "Lightweight BitTorrent client"
  homepage "http://www.transmissionbt.com/"
  url "https://download.transmissionbt.com/files/transmission-2.92.tar.xz"
  sha256 "3a8d045c306ad9acb7bf81126939b9594553a388482efa0ec1bfb67b22acd35f"

  bottle do
    sha256 "68af47554f408d92d04cbf86239a3d973cf7b4e9f0d254e127f5ead36074987a" => :el_capitan
    sha256 "2071f4bb87d9d5e7cf6885caa8cf8605d81b108a097259113ba295a3c1f90bb7" => :yosemite
    sha256 "9fb74d440426bbdf82d06dcd01e53db625cabfce0c4c85b15aec298007df6fd3" => :mavericks
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
