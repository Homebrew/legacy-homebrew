class Tor < Formula
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.2.5.12.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.2.5.12.tar.gz"
  sha256 "550fdafffeb4c1e3035bb8cc42e6e49d5af17ad79563bd118af22c1107f72b49"

  bottle do
    sha256 "8f4ed124a0505b2d78cbb77705d0b899865df6cdbb2ecbd8bf507a8cc14a270a" => :yosemite
    sha256 "033474dbd57cb7a5b0eb07b6a1c7391f746cec20ba77f935522cb9f0a106423f" => :mavericks
    sha256 "463d44d09c99754079bc28f036c7bd6e80a381a5c90b8245fcc9bc30d98a389b" => :mountain_lion
  end

  devel do
    url "https://dist.torproject.org/tor-0.2.6.7.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.2.6.7.tar.gz"
    sha256 "8c2be88a542ed1b22a8d3d595ec0acd0e28191de273dbcaefc64fdce92b89e6c"

    # Move this to the main block when current devel = stable release.
    depends_on "libscrypt" => :optional
  end

  depends_on "libevent"
  depends_on "openssl"
  depends_on "libnatpmp" => :optional
  depends_on "miniupnpc" => :optional

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
    args << "--disable-libscrypt" if build.devel? && build.without?("libscrypt")

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
