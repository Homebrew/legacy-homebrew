require 'formula'

class Ddclient < Formula
  homepage 'http://sourceforge.net/p/ddclient/wiki/Home'
  url 'https://downloads.sourceforge.net/project/ddclient/ddclient/ddclient-3.8.2/ddclient-3.8.2.tar.bz2'
  sha1 '8c887c06a580773c48a1eaced82a08c3077e1325'

  def install
    # Adjust default paths in script
    inreplace 'ddclient' do |s|
      s.gsub! "/etc/ddclient", "#{etc}/ddclient"
      s.gsub! "/var/cache/ddclient", "#{var}/run/ddclient"
    end

    sbin.install "ddclient"

    # Install sample files
    inreplace 'sample-ddclient-wrapper.sh',
      "/etc/ddclient", "#{etc}/ddclient"

    inreplace 'sample-etc_cron.d_ddclient',
      "/usr/sbin/ddclient", "#{sbin}/ddclient"

    inreplace 'sample-etc_ddclient.conf',
      "/var/run/ddclient.pid", "#{var}/run/ddclient/pid"

    (share+'doc/ddclient').install %w(
      sample-ddclient-wrapper.sh
      sample-etc_cron.d_ddclient
      sample-etc_ddclient.conf
    )

    # Create etc & var paths
    (etc+'ddclient').mkpath
    (var+'run/ddclient').mkpath
  end

  def caveats; <<-EOS.undent
    For ddclient to work, you will need to create a configuration file
    in #{etc}/ddclient, a sample configuration can be found in
    #{opt_share}/doc/ddclient.

    Note: don't enable daemon mode in the configuration file; see
    additional information below.

    The next reboot of the system will automatically start ddclient.

    You can adjust the execution interval by changing the value of
    StartInterval (in seconds) in /Library/LaunchDaemons/#{plist_path.basename},
    and then
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/ddclient</string>
        <string>-file</string>
        <string>#{etc}/ddclient/ddclient.conf</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>StartInterval</key>
      <integer>300</integer>
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
