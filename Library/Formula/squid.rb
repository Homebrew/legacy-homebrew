class Squid < Formula
  desc "Advanced proxy caching server for HTTP, HTTPS, FTP, and Gopher"
  homepage "http://www.squid-cache.org/"
  url "http://www.squid-cache.org/Versions/v3/3.5/squid-3.5.12.tar.xz"
  sha256 "8bc83f3869f7404aefb10883109e28443255cf6dde50a13904c7954619707a42"

  bottle do
    sha256 "9ff5b97fbcdb1789ca19dbaacc465fe0780c71893d28e6c63f80eb9ca547d835" => :el_capitan
    sha256 "ce4ffa2cd50625a056c74e71b6e18272936e00769c7d96508028546954c59a56" => :yosemite
    sha256 "d8417271c5ea6eef69aafd5ab0bf91a2988a98baf95f5ddaa3005c6187d81380" => :mavericks
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
