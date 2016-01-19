class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "http://www.squid-cache.org/"
  url "http://www.squid-cache.org/Versions/v3/3.5/squid-3.5.13.tar.xz"
  sha256 "e75d94671895270272883187296f17e26954bf00a090c97bfea8a4fc264a5b40"

  bottle do
    sha256 "a7f8f41682e8707076b9043a749f7d06aa8e43cbc957ede40638cb26b2f0dff7" => :el_capitan
    sha256 "d6b11c6c9c58aa1914c08d6b90253ebdb6c654bd06c4b5938dbf5697017c80cc" => :yosemite
    sha256 "1ffc8de5c4192a0b666348de146a69cb003a49919727eca37f68666c099ed8bc" => :mavericks
  end

  depends_on "openssl"

  def install
    # http://stackoverflow.com/questions/20910109/building-squid-cache-on-os-x-mavericks
    ENV.append "LDFLAGS", "-lresolv"

    # For --disable-eui, see:
    # http://squid-web-proxy-cache.1019090.n4.nabble.com/ERROR-ARP-MAC-EUI-operations-not-supported-on-this-operating-system-td4659335.html
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --enable-ssl
      --enable-ssl-crtd
      --disable-eui
      --enable-pf-transparent
      --with-included-ltdl
      --with-openssl
    ]

    system "./configure", *args
    system "make", "install"
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

  test do
    # This test should start squid and then check it runs correctly.
    # However currently dies under the sandbox and "Current Directory"
    # seems to be set hard on HOMEBREW_PREFIX/var/cache/squid.
    # https://github.com/Homebrew/homebrew/pull/44348#issuecomment-143477353
    # If you can fix this, please submit a PR. Thank you!
    assert_match version.to_s, shell_output("#{sbin}/squid -v")
  end
end
