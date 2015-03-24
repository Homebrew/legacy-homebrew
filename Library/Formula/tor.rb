class Tor < Formula
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.2.5.11.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.2.5.11.tar.gz"
  sha256 "aee0faee9c3f1bb265ee8e94b4bb93967413f3c56e65f954db16b09451546769"

  bottle do
    sha256 "bc5670c7be67d074c927fe55fa41d1acf3fa7d64b6d9da5c9b8c74361fd48d60" => :yosemite
    sha256 "cc9c18ae2604a7c5d55d60a99c59a46d6280bb3f08832bb1fba61fad0fe035a1" => :mavericks
    sha256 "267107884383f309e0dd1a0b3f137dc226c58c58c183592c4efd7a7b38e26ef3" => :mountain_lion
  end

  devel do
    url "https://dist.torproject.org/tor-0.2.6.5-rc.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.2.6.5-rc.tar.gz"
    sha256 "1a78bc971078c8aee1d0927bf6629610efef2cce31219580b2a73cc268d4103e"
    version "0.2.6.5-rc"

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
