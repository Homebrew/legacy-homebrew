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
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-firewall=ipfw"
    system "make install"
  end

  plist_options :startup => true

  def plist; <<-EOS
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
        <string>/var/log/secure.log</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end
end
