require "formula"

class Transmission < Formula
  homepage "http://www.transmissionbt.com/"
  url "http://download.transmissionbt.com/files/transmission-2.83.tar.xz"
  sha1 "d28bb66b3a1cccc2c4b42d21346be4fe84498ccb"

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

    #fixes issue w/ webui files not being found #21151
    #submitted upstream: https://trac.transmissionbt.com/ticket/5304
    inreplace "libtransmission/platform.c", "SYS_DARWIN", "BUILD_MAC_CLIENT"
    inreplace "libtransmission/utils.c", "SYS_DARWIN", "BUILD_MAC_CLIENT"

    system "./configure", *args
    system "make" # Make and install in one step fails
    system "make install"

    (var/"transmission").mkpath
  end

  def caveats; <<-EOS.undent
    This formula only installs the command line utilities.
    Transmission.app can be downloaded from Transmission's website:
      http://www.transmissionbt.com
    EOS
  end

  plist_options :manual => 'transmission-daemon --foreground'

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
      </dict>
    </plist>
    EOS
  end
end
