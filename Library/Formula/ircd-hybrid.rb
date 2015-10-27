class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "http://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.9/ircd-hybrid-8.2.9.tgz"
  sha256 "10594036c8f1502d61f68f8feb9216aaed8d611df36145e34746d93039a830a7"

  bottle do
    sha256 "01479a3ad06cb6dc0bad08bbd516ba9e870ab3d3745374c656adefa43705b236" => :el_capitan
    sha256 "5e370515a3c039cde596171d07ae4a854410288591e128b55579b97ef0d8ad5d" => :yosemite
    sha256 "8def15837e5e34f1dcbc4899289f887db1ede97358d1bb97310ab4ab3b2037cc" => :mavericks
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
