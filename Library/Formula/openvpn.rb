require 'formula'

class Openvpn < Formula
  homepage 'http://openvpn.net/'
  url 'http://build.openvpn.net/downloads/releases/openvpn-2.3.0.tar.gz'
  mirror 'http://swupdate.openvpn.org/community/releases/openvpn-2.3.0.tar.gz'
  sha256 '4602a8d0f66dfa6ac10b7abfeba35260d7d4c570948f6eba5f8216ffa3a2c490'

  depends_on 'lzo'

  def install
    # Build and install binary
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-password-save"
    system "make install"

    # Adjust sample file paths
    inreplace ["sample/sample-config-files/openvpn-startup.sh"] do |s|
      s.gsub! "/etc/openvpn", etc+'openvpn'
    end

    # Install sample files
    Dir['sample/sample-*'].each do |d|
      (share + 'doc/openvpn' + d).install Dir[d+'/*']
    end

    # Create etc & var paths
    (etc + 'openvpn').mkpath
    (var + 'run/openvpn').mkpath
  end

  def caveats; <<-EOS.undent
    You may also wish to install tuntap:

      The TunTap project provides kernel extensions for Mac OS X that allow
      creation of virtual network interfaces.

      http://tuntaposx.sourceforge.net/

    Because these are kernel extensions, there is no Homebrew formula for tuntap.

    For OpenVPN to work as a server, you will need to create configuration file
    in #{etc}/openvpn, samples can be found in #{share}/doc/openvpn
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd";>
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_prefix}/sbin/openvpn</string>
        <string>--config</string>
        <string>#{etc}/openvpn/openvpn.conf</string>
      </array>
      <key>OnDemand</key>
      <false/>
      <key>RunAtLoad</key>
      <true/>
      <key>TimeOut</key>
      <integer>90</integer>
      <key>WatchPaths</key>
      <array>
        <string>#{etc}/openvpn</string>
      </array>
      <key>WorkingDirectory</key>
      <string>#{etc}/openvpn</string>
    </dict>
    </plist>
    EOS
  end
end
