require 'formula'

class Bacula < Formula
  homepage 'http://www.bacula.org/'
  url 'http://dl.sourceforge.net/project/bacula/bacula/5.2.6/bacula-5.2.6.tar.gz'
  sha1 '471cf224d5566e65a3a6cebd59d13c25f0825a8a'

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--with-sqlite3", "--with-readline", "--with-openssl",
                          "--enable-largefile", "--without-mysql", "--enable-smartalloc",
                          "--enable-tray-monitor",
                          "--prefix=#{prefix}"
    system "make install"
    
    (prefix+"Library/LaunchDaemons/org.bacula-dir.plist").chmod 0644
    (prefix+"Library/LaunchDaemons/org.bacula-fd.plist").chmod 0644
    (prefix+"Library/LaunchDaemons/org.bacula-sd.plist").chmod 0644
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test bacula`.
    system "false"
  end

  def dir_plist
    return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>#{plist_name}</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>UserName</key>
    <string>#{`whoami`.chomp}</string>
    <key>ProgramArguments</key>
    <array>
        <string>#{HOMEBREW_PREFIX}/sbin/bacula-dir</string>
    </array>
    <key>WorkingDirectory</key>
    <string>#{HOMEBREW_PREFIX}</string>
  </dict>
</plist>
    EOPLIST
  end

  def caveats; <<-EOS.undent
    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/Library/LaunchDaemons/org.bacula-dir.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.bacula-dir.plist
        cp #{prefix}/Library/LaunchDaemons/org.bacula-sd.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.bacula-sd.plist
        cp #{prefix}/Library/LaunchDaemons/org.bacula-fd.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.bacula-fd.plist

    If this is an upgrade and you already have the org.bacula-xxx.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/org.bacula-dir.plist
        cp #{prefix}/Library/LaunchDaemons/org.bacula-dir.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.bacula-dir.plist
        launchctl unload -w ~/Library/LaunchAgents/org.bacula-sd.plist
        cp #{prefix}/Library/LaunchDaemons/org.bacula-sd.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.bacula-sd.plist
        launchctl unload -w ~/Library/LaunchAgents/org.bacula-fd.plist
        cp #{prefix}/Library/LaunchDaemons/org.bacula-fd.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.bacula-fd.plist

    Alternatively, automatically run on startup as a daemon with:
        sudo launchctl list org.bacula-dir \>/dev/null 2\>\&1 \&\& \\
        sudo launchctl unload -w /Library/LaunchDaemons/org.bacula-dir.plist
        sudo cp #{prefix}/Library/LaunchDaemons/org.bacula-dir.plist /Library/LaunchDaemons/
        sudo launchctl load -w /Library/LaunchDaemons/org.bacula-dir.plist
        sudo launchctl list org.bacula-sd \>/dev/null 2\>\&1 \&\& \\
        sudo launchctl unload -w /Library/LaunchDaemons/org.bacula-sd.plist
        sudo cp #{prefix}/Library/LaunchDaemons/org.bacula-sd.plist /Library/LaunchDaemons/
        sudo launchctl load -w /Library/LaunchDaemons/org.bacula-sd.plist
        sudo launchctl list org.bacula-fd \>/dev/null 2\>\&1 \&\& \\
        sudo launchctl unload -w /Library/LaunchDaemons/org.bacula-fd.plist
        sudo cp #{prefix}/Library/LaunchDaemons/org.bacula-fd.plist /Library/LaunchDaemons/
        sudo launchctl load -w /Library/LaunchDaemons/org.bacula-fd.plist

    Or start manually as the current user with:
        bconsole
    EOS
  end

end
