require 'formula'

class Pgbouncer < Formula
  homepage 'http://wiki.postgresql.org/wiki/PgBouncer'
  url 'http://pgfoundry.org/frs/download.php/3240/pgbouncer-1.5.1.tar.gz'
  md5 '90348e2583ba2fadecaa1aa3cc5a5e78'

  depends_on 'asciidoc' => :build
  depends_on 'xmlto' => :build
  depends_on 'libevent'

  def install
    ENV['XML_CATALOG_FILES'] = "#{etc}/xml/catalog"

    system "./configure", "--disable-debug",
                          "--with-libevent=#{HOMEBREW_PREFIX}",
                          "--prefix=#{prefix}"
    ln_s "../install-sh", "doc/install-sh"
    system "make install"
    bin.install "etc/mkauth.py"
    etc.install %w(etc/pgbouncer.ini etc/userlist.txt)

    plist_path.write startup_plist
    plist_path.chmod 0644
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
    cp #{plist_path} ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

If this is an upgrade and you already have the #{plist_path.basename}
loaded:
    launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
    cp #{plist_path} ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

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
  <string>#{plist_name}</string>
  <key>ProgramArguments</key>
  <array>
    <string>#{HOMEBREW_PREFIX}/bin/pgbouncer</string>
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
