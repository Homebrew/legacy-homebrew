require 'formula'

class Pgbouncer < Formula
  url 'http://pgfoundry.org/frs/download.php/3197/pgbouncer-1.5.tgz'
  homepage 'http://wiki.postgresql.org/wiki/PgBouncer'
  md5 '6179fdc7f7e3c702fe834d655676de4c'

  depends_on 'libevent'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--with-libevent=#{HOMEBREW_PREFIX}",
                          "--prefix=#{prefix}"
    system "ln -s ../install-sh doc/install-sh"
    system "make install"
    bin.install "etc/mkauth.py"
    etc.install %w(etc/pgbouncer.ini etc/userlist.txt)

    (prefix+'org.postgresql.pgbouncer.plist').write startup_plist
    (prefix+'org.postgresql.pgbouncer.plist').chmod 0644
  end

  def caveats
    s = <<-EOS
The config file: #{etc}/pgbouncer.ini is in the "ini" format and you
will need to edit it for your particular setup. See:
http://pgbouncer.projects.postgresql.org/doc/config.html

The auth_file option should point to the #{etc}/userlist.txt file which
can be populated by the #{bin}/mkauth.py script.

If this is your first install, automatically load on login with:
    mkdir -p ~/Library/LaunchAgents
    cp #{prefix}/org.postgresql.pgbouncer.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/org.postgresql.pgbouncer.plist

If this is an upgrade and you already have the org.postgresql.pgbouncer.plist
loaded:
    launchctl unload -w ~/Library/LaunchAgents/org.postgresql.pgbouncer.plist
    cp #{prefix}/org.postgresql.pgbouncer.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/org.postgresql.pgbouncer.plist

Or start manually with:
    pgbouncer -q #{etc}/pgbouncer.ini
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
  <string>org.postgresql.pgbouncer</string>
  <key>ProgramArguments</key>
  <array>
    <string>#{bin}/pgbouncer</string>
    <string>-d</string>
    <string>-q</string>
    <string>#{etc}/pgbouncer.ini</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>UserName</key>
  <string>#{`whoami`.chomp}</string>
  <key>WorkingDirectory</key>
  <string>#{HOMEBREW_PREFIX}</string>
</dict>
</plist>
    EOPLIST
  end
end
