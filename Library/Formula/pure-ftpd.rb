require 'formula'

class PureFtpd < Formula
  url 'http://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.35.tar.gz'
  homepage 'http://www.pureftpd.org/'
  md5 'fa53507ff8e9fdca0197917ec8d106a3'

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}", "--mandir=#{man}", "--sysconfdir=#{etc}",
            "--with-pam",
            "--with-altlog",
            "--with-puredb",
            "--with-throttling",
            "--with-ratios",
            "--with-quotas",
            "--with-ftpwho",
            "--with-virtualhosts",
            "--with-virtualchroot",
            "--with-diraliases",
            "--with-peruserlimits",
            "--with-tls",
            "--with-bonjour"]

    args << "--with-pgsql" if `/usr/bin/which pg_config`.size > 0
    args << "--with-mysql" if `/usr/bin/which mysql`.size > 0

    system "./configure", *args
    system "make install"
    (prefix+'org.pureftpd.pure-ftpd.plist').write startup_plist
    (prefix+'org.pureftpd.pure-ftpd.plist').chmod 0644
  end

  def caveats
    <<-EOS.undent
    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/org.pureftpd.pure-ftpd.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.pureftpd.pure-ftpd.plist

    If this is an upgrade and you already have the org.pureftpd.pure-ftpd.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/org.pureftpd.pure-ftpd.plist
        cp #{prefix}/org.pureftpd.pure-ftpd.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.pureftpd.pure-ftpd.plist

      To start pure-ftpd manually:
        pure-ftpd <options>
    EOS
  end

  def startup_plist
    return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>KeepAlive</key>
    <true/>
    <key>Label</key>
    <string>org.pureftpd.pure-ftpd</string>
    <key>ProgramArguments</key>
    <array>
      <string>#{sbin}/pure-ftpd</string>
      <string>-A -j -z</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>UserName</key>
    <string>#{`whoami`.chomp}</string>
    <key>WorkingDirectory</key>
    <string>#{var}</string>
    <key>StandardErrorPath</key>
    <string>#{var}/log/pure-ftpd.log</string>
    <key>StandardOutPath</key>
    <string>#{var}/log/pure-ftpd.log</string>
  </dict>
</plist>
    EOPLIST
  end
end
