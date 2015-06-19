class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.2.6.9.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.2.6.9.tar.gz"
  sha256 "4a6c29ad89a98d7832c599d9480d6d8e55355fb3b8f4b506c5df557f15942f9c"

  bottle do
    sha256 "9ba6b14b210770a7ad1ff11ef85fb1ec7dab3ba23ce999cf0f5123d6dd71659a" => :yosemite
    sha256 "c6986384324ee9c145b1e33041c033f00bb949ddd99b9c6a5d26556598461ba8" => :mavericks
    sha256 "c1ee6861812064687b9c32b61070e26a15a8bf10594b06577fe00083b88dc265" => :mountain_lion
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
