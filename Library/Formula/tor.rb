class Tor < Formula
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.2.6.7.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.2.6.7.tar.gz"
  sha256 "8c2be88a542ed1b22a8d3d595ec0acd0e28191de273dbcaefc64fdce92b89e6c"

  bottle do
    sha256 "0cddcd6e31bb6f9af1cd4313ee5b0f4eecd971d8a40e41fa8988971a271f40f1" => :yosemite
    sha256 "5b44acfc1a42c9824f8113584461ebdad5075187197ef3ebb3dff8c0df9abe29" => :mavericks
    sha256 "43258e2a46024eab2d031cb4904cb1b9562a7ffadd745bd126955a1a6d72f830" => :mountain_lion
  end

  devel do
    url "https://dist.torproject.org/tor-0.2.7.1-alpha.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.2.7.1-alpha.tar.gz"
    sha256 "9afc770a5a795e752f053ae7c2c1ee3a560145adc0aea377c83e602c2cbbed9b"
    version "0.2.7.1-alpha"
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
      </dict>
    </plist>
    EOS
  end

  def caveats; <<-EOS.undent
    You will find a sample `torrc` file in #{etc}/tor.
    It is advisable to edit the sample `torrc` to suit
    your own security needs:
      https://www.torproject.org/docs/faq#torrc
    After editing the `torrc` you need to restart tor.
    EOS
  end
end
