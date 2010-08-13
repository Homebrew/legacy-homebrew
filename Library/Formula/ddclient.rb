require 'formula'

class Ddclient <Formula
  url 'http://downloads.sourceforge.net/project/ddclient/ddclient/ddclient-3.8.0/ddclient-3.8.0.tar.bz2'
  homepage 'http://sourceforge.net/apps/trac/ddclient'
  md5 '6cac7a5eb1da781bfd4d98cef0b21f8e'

  skip_clean 'etc'
  skip_clean 'var'

  def install
    # Adjust default paths in script
    inreplace 'ddclient' do |s|
      s.gsub! "/etc/ddclient", (etc + 'ddclient')
      s.gsub! "/var/cache/ddclient", (var + 'run/ddclient')
    end

    # Copy script to sbin
    sbin.install "ddclient"

    # Install sample files
    inreplace 'sample-ddclient-wrapper.sh' do |s|
      s.gsub! "/etc/ddclient", (etc + 'ddclient')
    end
    inreplace 'sample-etc_cron.d_ddclient' do |s|
      s.gsub! "/usr/sbin/ddclient", (sbin + 'ddclient')
    end
    inreplace 'sample-etc_ddclient.conf' do |s|
      s.gsub! "/var/run/ddclient.pid", (var + 'run/ddclient/pid')
    end
    (share + 'doc/ddclient').install ['sample-ddclient-wrapper.sh',\
                                          'sample-etc_cron.d_ddclient',\
                                          'sample-etc_ddclient.conf']

    # Create etc & var paths
    (etc + 'ddclient').mkpath
    (var + 'run/ddclient').mkpath

    # Write the launchd script
    (prefix + 'org.ddclient.plist').write startup_plist
  end

  def caveats; <<-EOS
For ddclient to work, you will need to do the following:

1) Create configuration file in #{etc}/ddclient, sample
   configuration can be found in #{share}/doc/ddclient

2) Install the launchd item in /Library/LaunchDaemons, like so:

   sudo cp -vf #{prefix}/org.ddclient.plist /Library/LaunchDaemons/.
   sudo chown -v root:wheel /Library/LaunchDaemons/org.ddclient.plist

3) Start the daemon using:

   sudo launchctl load /Library/LaunchDaemons/org.ddclient.plist

Next boot of system will automatically start ddclient.
EOS
  end

  def startup_plist
    return <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>org.ddclient</string>
	<key>OnDemand</key>
	<true/>
	<key>ProgramArguments</key>
	<array>
		<string>#{sbin}/ddclient</string>
		<string>-file</string>
		<string>#{etc}/ddclient/ddclient.conf</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
	<key>StartCalendarInterval</key>
	<dict>
		<key>Minute</key>
		<integer>0</integer>
	</dict>
	<key>WatchPaths</key>
	<array>
		<string>#{etc}/ddclient</string>
	</array>
	<key>WorkingDirectory</key>
	<string>#{etc}/ddclient</string>
</dict>
</plist>
EOS
  end
end
