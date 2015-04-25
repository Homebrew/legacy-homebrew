require "formula"

class Squid < Formula
  homepage "http://www.squid-cache.org/"
  url "http://www.squid-cache.org/Versions/v3/3.4/squid-3.4.12.tar.bz2"
  sha1 "e5291d1a556313712410cf6297f08e895a2d679a"

  bottle do
    sha256 "9db04b2b64b0e14f1f0698d6fc35734bb4f52706e4dcd54dc6a897810eb15813" => :yosemite
    sha256 "8f7dcd0316187261706152b2b770eb9a647501b59b48fe85e07d624d32a26cb9" => :mavericks
    sha256 "dc06c4c6d3d387eaf6d4901870b1ca7f07c816e2ba6fcf69b10dcb9610fdd922" => :mountain_lion
  end

  depends_on "openssl"

  def install
    # http://stackoverflow.com/questions/20910109/building-squid-cache-on-os-x-mavericks
    ENV.append "LDFLAGS",  "-lresolv"

    # For --disable-eui, see:
    # http://squid-web-proxy-cache.1019090.n4.nabble.com/ERROR-ARP-MAC-EUI-operations-not-supported-on-this-operating-system-td4659335.html
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
      --enable-ssl
      --enable-ssl-crtd
      --disable-eui
      --enable-pf-transparent
      --with-included-ltdl
    ]

    system "./configure", *args
    system "make install"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/squid</string>
        <string>-N</string>
        <string>-d 1</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
    EOS
  end
end
