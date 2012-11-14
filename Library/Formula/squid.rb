require 'formula'

class NoBdb5 < Requirement
  def message; <<-EOS.undent
    This software can fail to compile when Berkeley-DB 5.x is installed.
    You may need to try:
      brew unlink berkeley-db
      brew install squid
      brew link berkeley-db
    EOS
  end

  def satisfied?
    f = Formula.factory("berkeley-db")
    not f.installed?
  end

  # Not fatal in case Squid starts working with a newer version of BDB.
  def fatal?
    false
  end
end

class Squid < Formula
  homepage 'http://www.squid-cache.org/'
  url 'http://www.squid-cache.org/Versions/v3/3.2/squid-3.2.2.tar.gz'
  sha1 '3df827e5eb861df0b6ac7654ef738512cb3f9297'

  depends_on NoBdb5.new

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make install"
  end

  def caveats; <<-EOS.undent

    To launch on startup:

      * if this is your first install:
          mkdir -p ~/Library/LaunchAgents
          cp #{plist_path} ~/Library/LaunchAgents/
          launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

      * if this is an upgrade and you already have the #{plist_path.basename} loaded:
          launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
          cp #{plist_path} ~/Library/LaunchAgents/
          launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    EOS
  end

  def startup_plist; <<-EOPLIST.undent
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
        <string>/usr/local/sbin/squid</string>
        <string>-N</string>
        <string>-d 1</string>
        <string>-D</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>UserName</key>
      <string>#{`whoami`.chomp}</string>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
    EOPLIST
  end
end
