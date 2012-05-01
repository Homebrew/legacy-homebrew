require 'formula'

class Ser2net < Formula
  homepage 'http://ser2net.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/ser2net/ser2net/2.7/ser2net-2.7.tar.gz'
  md5 '22977477789868923a5de09a85e847dd'

  def install
    ENV.deparallelize

    # Fix etc location
    inreplace ["ser2net.c", "ser2net.8"], "/etc/ser2net.conf", "#{etc}/ser2net.conf"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
    etc.install 'ser2net.conf'

    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def caveats; <<-EOS.undent
    Serial to Network Proxy (ser2net)

    ser2net provides a way for a user to connect from a network connection to a serial port.
    It provides all the serial port setup, a configuration file to configure the ports, a
    control login for modifying port parameters, monitoring ports, and controlling ports.

    To configure ser2net, edit the example configuration in #{etc}/ser2net.conf

    To start manually ser2net server:
      ser2net -p 12345
    where 12345 is the port on which sernet will listen to control commands

    You can start ser2net automatically on login running as your user with:
      mkdir -p ~/Library/LaunchAgents
      cp #{plist_path} ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}
    EOS
  end

  def startup_plist
    return <<-EOPLIST
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
    <key>UserName</key>
    <string>#{`whoami`.chomp}</string>
    <key>ProgramArguments</key>
    <array>
        <string>#{HOMEBREW_PREFIX}/sbin/ser2net</string>
        <string>-p</string>
        <string>12345</string>
    </array>
    <key>WorkingDirectory</key>
    <string>#{HOMEBREW_PREFIX}</string>
  </dict>
</plist>
    EOPLIST
  end
end
