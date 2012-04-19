require 'formula'

class Rabbitmq < Formula
  homepage 'http://www.rabbitmq.com'
  url 'http://www.rabbitmq.com/releases/rabbitmq-server/v2.8.1/rabbitmq-server-2.8.1.tar.gz'
  md5 'f2ccd96c751429dc82f811c185e2f497'

  depends_on 'erlang'
  depends_on 'simplejson' => :python if MacOS.leopard?

  def install
    # Building the manual requires additional software, so skip it.
    inreplace "Makefile", "install: install_bin install_docs", "install: install_bin"

    target_dir = "#{lib}/rabbitmq/erlang/lib/rabbitmq-#{version}"
    system "make"
    ENV['TARGET_DIR'] = target_dir
    ENV['MAN_DIR'] = man
    ENV['SBIN_DIR'] = sbin
    system "make install"

    inreplace sbin+'rabbitmq-defaults', "SYS_PREFIX=", "SYS_PREFIX=#{prefix}" 

    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def caveats
    <<-EOS.undent
    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    If this is an upgrade and you already have the #{plist_path.basename} loaded:
        launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

      To start rabbitmq-server manually:
        rabbitmq-server
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
    <string>#{plist_name}</string>
    <key>Program</key>
    <string>#{HOMEBREW_PREFIX}/sbin/rabbitmq-server</string>
    <key>RunAtLoad</key>
    <true/>
    <key>UserName</key>
    <string>#{`whoami`.chomp}</string>
    <!-- need erl in the path -->
    <key>EnvironmentVariables</key>
    <dict>
      <key>PATH</key>
      <string>/usr/local/sbin:/usr/bin:/bin:/usr/local/bin</string>
    </dict>
  </dict>
</plist>
    EOPLIST
  end
end
