require "formula"

class IrcdHybrid < Formula
  homepage "http://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.1.18/ircd-hybrid-8.1.18.tgz"
  sha1 "2dbb4a3dfd4b51d9f0cdcb587720c711e2147ff6"
  revision 1

  bottle do
    sha1 "67f2b1c0d89f186ac93c1cb79704090727ab51c5" => :mavericks
    sha1 "578daf6e02e39721fb1cf3db4c3ff17f96360479" => :mountain_lion
    sha1 "bc00b8dfc221aed2f61b7480733b7dd052db052e" => :lion
  end

  # ircd-hybrid needs the .la files
  skip_clean :la

  depends_on "openssl"

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
