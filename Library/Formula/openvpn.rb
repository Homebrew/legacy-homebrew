require 'formula'

class Openvpn <Formula
  url 'http://openvpn.net/release/openvpn-2.1.1.tar.gz'
  homepage 'http://openvpn.net/'
  md5 'b273ed2b5ec8616fb9834cde8634bce7'

  depends_on 'lzo' => :recommended

  skip_clean 'etc'
  skip_clean 'var'

  def install
    # Build and install binary
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"

    # Adjust sample file paths
    inreplace ["sample-config-files/openvpn-startup.sh", "sample-scripts/openvpn.init"] do |s|
      s.gsub! "/etc/openvpn", (etc + 'openvpn')
      s.gsub! "/var/run/openvpn", (var + 'run/openvpn')
    end

    # Install sample files
    Dir['sample-*'].each do |d|
      (share + 'doc/openvpn' + d).install Dir[d+'/*']
    end

    # Create etc & var paths
    (etc + 'openvpn').mkpath
    (var + 'run/openvpn').mkpath

    # Write the launchd script
    (prefix + 'org.openvpn.plist').write startup_plist
  end

  def caveats; <<-EOS
For OpenVPN to work as a server, you will need to do the following:

1) Create configuration file in #{etc}/openvpn, samples can be
   found in #{share}/doc/openvpn

2) Install the launchd item in /Library/LaunchDaemons, like so:

   sudo cp -vf #{prefix}/org.openvpn.plist /Library/LaunchDaemons/.
   sudo chown -v root:wheel /Library/LaunchDaemons/org.openvpn.plist

3) Start the daemon using:

   sudo launchctl load /Library/LaunchDaemons/org.openvpn.plist

Next boot of system will automatically start OpenVPN.
EOS
  end

  def startup_plist
    return <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd";>
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>org.openvpn</string>
	<key>ProgramArguments</key>
	<array>
		<string>#{sbin}/openvpn</string>
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
