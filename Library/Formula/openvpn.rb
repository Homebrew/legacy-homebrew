require 'formula'

class Openvpn < Formula
  homepage 'http://openvpn.net/index.php/download/community-downloads.html'
  url 'http://build.openvpn.net/downloads/releases/openvpn-2.3.4.tar.gz'
  mirror 'http://swupdate.openvpn.org/community/releases/openvpn-2.3.4.tar.gz'
  sha256 'af506d5f48568fa8d2f2435cb3fad35f9a9a8f263999ea6df3ba296960cec85a'

  depends_on 'lzo'
  depends_on 'tuntap'

  def install
    # pam_appl header is installed in a different location on Leopard
    # and older; reported upstream https://community.openvpn.net/openvpn/ticket/326
    if MacOS.version < :snow_leopard
      %w[auth-pam.c pamdl.c].each do |file|
        inreplace "src/plugins/auth-pam/#{file}",
          "security/pam_appl.h", "pam/pam_appl.h"
      end
    end

    # Build and install binary
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-password-save"
    system "make install"

    # Adjust sample file paths
    inreplace "sample/sample-config-files/openvpn-startup.sh",
      "/etc/openvpn", "#{etc}/openvpn"

    # Install sample files
    (doc/"sample").install Dir["sample/sample-*"]

    # Create etc & var paths
    (etc + 'openvpn').mkpath
    (var + 'run/openvpn').mkpath
  end

  def caveats; <<-EOS.undent
    Make sure to follow the directions given by `brew info tuntap`
    before trying to use OpenVPN.

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
        <string>#{opt_sbin}/openvpn</string>
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
