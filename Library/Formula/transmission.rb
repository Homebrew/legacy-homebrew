class Transmission < Formula
  desc "Lightweight BitTorrent client"
  homepage "http://www.transmissionbt.com/"
  url "https://transmission.cachefly.net/transmission-2.84.tar.xz"
  sha256 "a9fc1936b4ee414acc732ada04e84339d6755cd0d097bcbd11ba2cfc540db9eb"

  bottle do
    sha256 "ad78662725cb4b924a7c1f7ad2fe1de2e9b8bf998233aee26b0f51c23d53b4de" => :yosemite
    sha256 "488408f72a451333d1c06e71bbc100cba255c4cfd541645ce1f7e4e800212d01" => :mavericks
    sha256 "3e20545a9e0ca3a4c11e645585427cb00be1cebbf7a76f76fce595ff883fd11c" => :mountain_lion
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

    # fixes issue w/ webui files not being found #21151
    # submitted upstream: https://trac.transmissionbt.com/ticket/5304
    inreplace "libtransmission/platform.c", "SYS_DARWIN", "BUILD_MAC_CLIENT"
    inreplace "libtransmission/utils.c", "SYS_DARWIN", "BUILD_MAC_CLIENT"

    system "./configure", *args
    system "make" # Make and install in one step fails
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
end
