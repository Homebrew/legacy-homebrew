require 'brewkit'

class Dovecot <Formula
  @url='http://www.dovecot.org/releases/1.2/dovecot-1.2.4.tar.gz'
  @homepage='http://dovecot.org/'
  @md5='3e5717d13e3d6b32d3f4b809df397dbf'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--sysconfdir=#{prefix}/etc",
                          "--localstatedir=#{prefix}/var",
                          "--with-ssl=openssl",
                          "--with-ioloop=kqueue"
    system "make install"

    # TODO: automate some of the caveats?
  end

  def caveats; <<-EOS
For Dovecot to work, you will need to do the following:

1) create configuration in #{prefix}/etc

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
                <string>#{prefix}/sbin/dovecot</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
</dict>
</plist>

4) start the server using: sudo launchctl load /Library/LaunchDaemons/org.dovecot.plist 
    EOS
  end
end
