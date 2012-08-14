require 'formula'

class Rabbitmq < Formula
  homepage 'http://www.rabbitmq.com'
  url 'http://www.rabbitmq.com/releases/rabbitmq-server/v2.8.5/rabbitmq-server-generic-unix-2.8.5.tar.gz'
  sha1 '40e9f4934f471088e781dc71f738708e1a213c74'

  depends_on 'erlang'
  depends_on 'simplejson' => :python if MacOS.leopard?

  def install
    # Install the base files
    prefix.install Dir['*']

    # Setup the lib files
    (var+'lib/rabbitmq').mkpath
    (var+'log/rabbitmq').mkpath

    # Replace the SYS_PREFIX for things like rabbitmq-plugins
    inreplace (sbin + 'rabbitmq-defaults'), 'SYS_PREFIX=${RABBITMQ_HOME}', "SYS_PREFIX=#{HOMEBREW_PREFIX}"

    # Set the RABBITMQ_HOME in rabbitmq-env
    inreplace (sbin + 'rabbitmq-env'), 'RABBITMQ_HOME="${SCRIPT_DIR}/.."', "RABBITMQ_HOME=#{prefix}"

    # Create the rabbitmq-env.conf file
    rabbitmq_env_conf = etc+'rabbitmq/rabbitmq-env.conf'
    rabbitmq_env_conf.write rabbitmq_env unless rabbitmq_env_conf.exist?

    # Enable the management web UI
    enabled_plugins_path = etc+'rabbitmq/enabled_plugins'
    enabled_plugins_path.write enabled_plugins unless enabled_plugins_path.exist?

    # Create the plist file
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

    Management Plugin enabled by default at http://localhost:55672

    To start rabbitmq-server manually:
        rabbitmq-server
    EOS
  end

  def enabled_plugins
    return <<-EOS.undent
      [rabbitmq_management,rabbitmq_management_visualiser].
    EOS
  end

  def rabbitmq_env
    return <<-EOS.undent
    CONFIG_FILE=#{etc}/rabbitmq/rabbitmq
    NODE_IP_ADDRESS=127.0.0.1
    NODENAME=rabbit@localhost
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
    <key>EnvironmentVariables</key>
    <dict>
      <!-- need erl in the path -->
      <key>PATH</key>
      <string>/usr/local/sbin:/usr/bin:/bin:/usr/local/bin</string>
      <!-- specify the path to the rabbitmq-env.conf file -->
      <key>CONF_ENV_FILE</key>
      <string>#{etc}/rabbitmq/rabbitmq-env.conf</string>
    </dict>
  </dict>
</plist>
    EOPLIST
  end
end
