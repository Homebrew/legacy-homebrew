require "formula"

class Squid < Formula
  homepage "http://www.squid-cache.org/"
  url "http://www.squid-cache.org/Versions/v3/3.4/squid-3.4.7.tar.bz2"
  sha1 "724bc2f7aa2b7dab4111305af3f243b84468689f"

  bottle do
    sha1 "f505e4b18fae3fc4423bce935e9e859e003f34ab" => :mavericks
    sha1 "7454588e02bcf4ffaadb8d3b17e20db5ede2a4cf" => :mountain_lion
    sha1 "489cd4206f99ec11bd6c6a48bfa8557e2348bed1" => :lion
  end

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
