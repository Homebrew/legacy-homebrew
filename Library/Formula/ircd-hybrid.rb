require 'formula'

class IrcdHybrid < Formula
  homepage 'http://www.ircd-hybrid.org/'
  url 'http://sourceforge.net/projects/ircd-hybrid/files/ircd-hybrid/ircd-hybrid-8.0.4/ircd-hybrid-8.0.4.tgz'
  sha1 '610df82fba0f5c21202c3d4910f9d68ae220ebcb'

  # ircd-hybrid needs the .la files
  skip_clean :la

  # system openssl fails with undefined symbols: "_SSL_CTX_clear_options"
  depends_on 'openssl' if MacOS.version < :lion

  def install
    ENV.j1 # build system trips over itself

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          # there's no config setting for this so set it to something generous
                          "--with-nicklen=30"
    system "make install"
  end

  def test
    system "#{sbin}/ircd", "-version"
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
        <string>#{opt_prefix}/sbin/ircd</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>UserName</key>
      <string>#{`whoami`.chomp}</string>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/ircd.log</string>
    </dict>
    </plist>
    EOS
  end
end
