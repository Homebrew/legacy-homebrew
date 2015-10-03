class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "http://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.8/ircd-hybrid-8.2.8.tgz"
  sha256 "651031ca86c829535ef91ff8a344c36cd5d79d2c6fb4a1c10bbd12a3b8fb2f9f"

  bottle do
    sha256 "0967877f3d687ece2b7dd5bf132ceadfbed5ecdf003102c17cbb8d061c8ba5c6" => :yosemite
    sha256 "e723c57f791e6ff5dc0dd6fe7a54f782da0176ce4c750cc7ad8f6d364afaa876" => :mavericks
    sha256 "e7753f62a75b4fa22603897487352132833b2602d790b1af1e0ab94415e751d2" => :mountain_lion
  end

  # ircd-hybrid needs the .la files
  skip_clean :la

  depends_on "openssl"

  conflicts_with "ircd-irc2", :because => "both install an `ircd` binary"

  def install
    ENV.j1 # build system trips over itself

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--enable-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
    etc.install "doc/reference.conf" => "ircd.conf"
  end

  test do
    system "#{bin}/ircd", "-version"
  end

  def caveats; <<-EOS.undent
    You'll more than likely need to edit the default settings in the config file:
      #{etc}/ircd.conf
    EOS
  end

  plist_options :manual => "ircd"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <false/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/ircd</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/ircd.log</string>
    </dict>
    </plist>
    EOS
  end
end
