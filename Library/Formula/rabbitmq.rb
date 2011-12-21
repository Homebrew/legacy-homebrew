require 'formula'

class Rabbitmq < Formula
  homepage 'http://www.rabbitmq.com'
  url 'http://www.rabbitmq.com/releases/rabbitmq-server/v2.7.1/rabbitmq-server-2.7.1.tar.gz'
  md5 '44eb09d2dff8ce641a1fe7f255a4c546'

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

    (etc+'rabbitmq').mkpath
    (var+'lib/rabbitmq').mkpath
    (var+'log/rabbitmq').mkpath

    %w{rabbitmq-server rabbitmqctl rabbitmq-env rabbitmq-plugins}.each do |script|
      inreplace sbin+script do |s|
        s.gsub! '/etc/rabbitmq', "#{etc}/rabbitmq"
        s.gsub! '/var/lib/rabbitmq', "#{var}/lib/rabbitmq"
        s.gsub! '/var/log/rabbitmq', "#{var}/log/rabbitmq"
      end
    end

    # RabbitMQ Erlang binaries are installed in lib/rabbitmq/erlang/lib/rabbitmq-x.y.z/ebin
    # therefore need to add this path for erl -pa
    inreplace sbin+'rabbitmq-env', '${SCRIPT_DIR}/..', target_dir

    (prefix+'com.rabbitmq.rabbitmq-server.plist').write startup_plist
    (prefix+'com.rabbitmq.rabbitmq-server.plist').chmod 0644
  end

  def caveats
    <<-EOS.undent
    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/com.rabbitmq.rabbitmq-server.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/com.rabbitmq.rabbitmq-server.plist

    If this is an upgrade and you already have the com.rabbitmq.rabbitmq-server.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/com.rabbitmq.rabbitmq-server.plist
        cp #{prefix}/com.rabbitmq.rabbitmq-server.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/com.rabbitmq.rabbitmq-server.plist

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
    <string>com.rabbitmq.rabbitmq-server</string>
    <key>Program</key>
    <string>/usr/local/sbin/rabbitmq-server</string>
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
