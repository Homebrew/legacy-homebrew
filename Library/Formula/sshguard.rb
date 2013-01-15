require 'formula'

class Sshguard < Formula
  homepage 'http://www.sshguard.net/'
  url 'http://downloads.sourceforge.net/project/sshguard/sshguard/sshguard-1.5/sshguard-1.5.tar.bz2'
  sha1 'f8f713bfb3f5c9877b34f6821426a22a7eec8df3'

  def patches
    # Fix blacklist flag (-b) so that it doesn't abort on first usage.
    # Upstream bug report:
    # http://sourceforge.net/tracker/?func=detail&aid=3252151&group_id=188282&atid=924685
    "https://sourceforge.net/tracker/download.php?group_id=188282&atid=924685&file_id=405677&aid=3252151"
  end

  def install
    args = %W[--prefix=#{prefix} --disable-debug --disable-dependency-tracking]
    if MacOS.version < :lion
      args << "--with-firewall=ipfw"
    else
      args << "--with-firewall=pf"
    end

    system './configure', *args
    system "make install"

    ssh_log = '/var/log/system.log'
    if MacOS.version < :lion
      ssh_log = '/var/log/secure.log'
    end
    plist_path().write sshguard_plist(ssh_log)
    plist_path().chmod 0644
  end

  def caveats
    s = []

    if MacOS.version >= :lion
      s << <<-EOS.undent
        To launch sshguard on bootup:
          cp #{plist_path().to_s} /Library/LaunchDaemons/
          sudo launchctl load -w /Library/LaunchDaemons/#{plist_name()}

        Add the following lines to /etc/pf.conf to block entries in the sshguard
        table (replace $ext_if with your WAN interface):

          table <sshguard> persist
          block in quick on $ext_if proto tcp from any to any port 22 label "ssh bruteforce"

        Then run sudo pfctl -f /etc/pf.conf to reload the rules.
      EOS
    end

    s.join "\n"
  end

  plist_options :startup => true

  def sshguard_plist(log_path); <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>KeepAlive</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_prefix}/sbin/sshguard</string>
        <string>-l</string>
        <string>#{log_path}</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end
end
