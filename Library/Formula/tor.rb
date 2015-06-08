class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.2.6.8.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.2.6.8.tar.gz"
  sha256 "b88b363896454250c3f561b0b48479f18295c93596d2e81baa10c5a3ae609a76"

  bottle do
    sha256 "8e951125ab8ccec4f75f042f07bded3b08c4c970b84d84a6962249b7290ba86d" => :yosemite
    sha256 "4e99238ca821986b63c7b524774c9173ad8b9f0e5075266f9fe254ff0103b0a9" => :mavericks
    sha256 "a0316b566f6214a0b476f916c8810375bf964844d622512f3faf1ad68bac5ed9" => :mountain_lion
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
