require 'formula'

class Nut < Formula
  url 'http://www.networkupstools.org/source/2.6/nut-2.6.1.tar.gz'
  homepage 'http://www.networkupstools.org/'
  md5 '89e6405272cc82c53d7b84160945761b'

  depends_on 'neon'
  depends_on 'libusb-compat' unless ARGV.include? '--no-usb'
  depends_on 'libgd' unless ARGV.include? '--no-cgi'

  def options
    [
      ['--no-usb', 'Build without USB support.'],
      ['--no-cgi', 'Build without CGI support.'],
    ]
  end

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-user=nobody",
            "--with-group=wheel"]
    args << "--with-usb" unless ARGV.include? '--no-usb'
    args << "--with-cgi" unless ARGV.include? '--no-cgi'

    system "./configure", *args
    system "make install"
    (prefix+'org.networkupstools.upsdrvctl.plist').write upsdrvctl_startup_plist
    (prefix+'org.networkupstools.upsd.plist').write upsd_startup_plist
    (prefix+'org.networkupstools.upsmon.plist').write upsmon_startup_plist
  end

  def caveats
    s = <<-EOS
The NUT config files live in #{etc}

To run upsdrvctl and upsd at boot:

  sudo cp #{prefix}/org.networkupstools.upsdrvctl.plist /Library/LaunchDaemons/
  sudo cp #{prefix}/org.networkupstools.upsd.plist /Library/LaunchDaemons/
  sudo launchctl load -w /Library/LaunchDaemons/org.networkupstools.upsdrvctl.plist
  sudo launchctl load -w /Library/LaunchDaemons/org.networkupstools.upsd.plist

To run upsmon at boot:

  sudo cp #{prefix}/org.networkupstools.upsmon.plist /Library/LaunchDaemons/
  sudo launchctl load -w /Library/LaunchDaemons/org.networkupstools.upsmon.plist

EOS

    if not ARGV.include? '--no-cgi'
      s << "The CGI executable was installed to #{prefix}/cgi-bin/upsstats.cgi\n\n"
    end

    return s
  end

  def upsdrvctl_startup_plist
    return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>UserName</key>
        <string>nobody</string>
        <key>GroupName</key>
        <string>wheel</string>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>org.networkupstools.upsdrvctl</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{prefix}/bin/upsdrvctl</string>
            <string>start</string>
        </array>
</dict>
</plist>
    EOPLIST
  end

  def upsd_startup_plist
    return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>UserName</key>
        <string>nobody</string>
        <key>GroupName</key>
        <string>wheel</string>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>org.networkupstools.upsd</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{prefix}/sbin/upsd</string>
        </array>
</dict>
</plist>
    EOPLIST
  end

  def upsmon_startup_plist
    return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>UserName</key>
        <string>nobody</string>
        <key>GroupName</key>
        <string>wheel</string>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>org.networkupstools.upsmon</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{prefix}/sbin/upsmon</string>
        </array>
</dict>
</plist>
    EOPLIST
  end
end
