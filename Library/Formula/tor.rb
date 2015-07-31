class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.2.6.10.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.2.6.10.tar.gz"
  sha256 "0542c0efe43b86619337862fa7eb02c7a74cb23a79d587090628a5f0f1224b8d"

  bottle do
    sha256 "acf689a5cf4ac59116b04cc271d999aea16d6dac44d8dce3b873a9ac0f854433" => :yosemite
    sha256 "b6e02ebdbc250b0beb199e55135d9514e88b3c195f442931ef8528bb9de8680c" => :mavericks
    sha256 "6e4085a67f555cb0b34b74818fb4f43dcc353d653100633aefa85804148f5d5e" => :mountain_lion
  end

  devel do
    url "https://dist.torproject.org/tor-0.2.7.2-alpha.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.2.7.2-alpha.tar.gz"
    sha256 "006de44b01e15916b1f648df92723c2a7d58e6a2cd05484d70d0af2f566b330c"
    version "0.2.7.2-alpha"
  end

  depends_on "libevent"
  depends_on "openssl"
  depends_on "libnatpmp" => :optional
  depends_on "miniupnpc" => :optional
  depends_on "libscrypt" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-openssl-dir=#{Formula["openssl"].opt_prefix}
    ]

    args << "--with-libnatpmp-dir=#{Formula["libnatpmp"].opt_prefix}" if build.with? "libnatpmp"
    args << "--with-libminiupnpc-dir=#{Formula["miniupnpc"].opt_prefix}" if build.with? "miniupnpc"
    args << "--disable-libscrypt" if build.without? "libscrypt"

    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    You will find a sample `torrc` file in #{etc}/tor.
    It is advisable to edit the sample `torrc` to suit
    your own security needs:
      https://www.torproject.org/docs/faq#torrc
    After editing the `torrc` you need to restart tor.
    EOS
  end

  test do
    system bin/"tor", "--version"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/tor</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/tor.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/tor.log</string>
      </dict>
    </plist>
    EOS
  end
end
