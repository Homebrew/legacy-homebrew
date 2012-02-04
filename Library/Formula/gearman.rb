require 'formula'

class Gearman < Formula
  url 'http://launchpad.net/gearmand/trunk/0.26/+download/gearmand-0.26.tar.gz'
  homepage 'http://gearman.org/'
  md5 '52a8cc98f649980331cc8011d47af09f'

  depends_on 'libevent'
  depends_on 'boost'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
    (prefix+'org.gearman.gearmand.plist').write startup_plist
    (prefix+'org.gearman.gearmand.plist').chmod 0644
  end

  def caveats
    <<-EOS.undent
    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/org.gearman.gearmand.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.gearman.gearmand.plist

    If this is an upgrade and you already have the org.gearman.gearmand.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/org.gearman.gearmand.plist
        cp #{prefix}/org.gearman.gearmand.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.gearman.gearmand.plist

      To start gearmand manually:
        gearmand -d
    EOS
  end

  def startup_plist
    return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>org.gearman.gearmand</string>
    <key>Program</key>
    <string>#{sbin}/gearmand</string>
    <key>RunAtLoad</key>
    <true/>
    <key>UserName</key>
    <string>#{`whoami`.chomp}</string>
  </dict>
</plist>
    EOPLIST
  end
end
