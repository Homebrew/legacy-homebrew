require 'formula'

class Dovecot <Formula
  url 'http://www.dovecot.org/releases/1.2/dovecot-1.2.11.tar.gz'
  homepage 'http://dovecot.org/'
  md5 'bdac013fd57aa616ea4bdd9ac34557c6'

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
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
        "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>Label</key>
        <string>org.dovecot</string>
        <key>ProgramArguments</key>
        <array>
                <string>#{sbin}/dovecot</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
</dict>
</plist>

4) start the server using: sudo launchctl load /Library/LaunchDaemons/org.dovecot.plist 
    EOS
  end
end
