require 'formula'

class Dovecot <Formula
  url 'http://www.dovecot.org/releases/1.2/dovecot-1.2.12.tar.gz'
  homepage 'http://dovecot.org/'
  md5 'cc8e5c53cd0943ce0b5e1087356ad4ea'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-ssl=openssl"
    system "make install"
  end

  def caveats; <<-EOS
For Dovecot to work, you will need to do the following:

1) Create configuration in #{etc}

2) If required by the configuration above, create a dovecot user and group

3) possibly create a launchd item in /Library/LaunchDaemons/org.dovecot.plist, like so:
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>Label</key>
        <string>org.dovecot</string>
        <key>OnDemand</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
                <string>#{sbin}/dovecot</string>
                <string>-F</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>ServiceDescription</key>
        <string>Dovecot mail server</string>
</dict>
</plist>

Source: http://wiki.dovecot.org/LaunchdInstall
4) start the server using: sudo launchctl load /Library/LaunchDaemons/org.dovecot.plist
    EOS
  end
end
