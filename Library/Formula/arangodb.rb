require 'formula'

class Arangodb < Formula
  homepage 'http://www.arangodb.org/'
  url 'https://github.com/triAGENS/ArangoDB/zipball/v1.0.0'
  sha1 '2a3b58967f41116cb9422e3e159ea526081310c7'

  head "https://github.com/triAGENS/ArangoDB.git"

  depends_on 'libev'
  depends_on 'v8'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-relative",
                          "--disable-all-in-one",
                          "--enable-mruby",
                          "--datadir=#{share}",
                          "--localstatedir=#{var}"

    system "make install"

    (var+'arangodb').mkpath
    (var+'log/arangodb').mkpath

    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def caveats; <<-EOS.undent
    Please note that this is a very early version if ArangoDB. There will be
    bugs and the ArangoDB team would really appreciate it if you report them:

      https://github.com/triAGENS/ArangoDB/issues

    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    If this is an upgrade and you already have the #{plist_path.basename} loaded:
        launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    To start the ArangoDB server manually, run:
        /usr/local/sbin/arangod

    To start the ArangoDB shell, run:
        arangosh
    EOS
  end

  def startup_plist
    return <<-EOS
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
      <string>#{HOMEBREW_PREFIX}/sbin/arangod</string>
      <string>-c</string>
      <string>#{etc}/arangodb/arangod.conf</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>UserName</key>
    <string>#{`whoami`.chomp}</string>
  </dict>
</plist>
    EOS
  end
end
