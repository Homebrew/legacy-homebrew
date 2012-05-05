require 'formula'

class Rabbitmq < Formula
  homepage 'http://www.rabbitmq.com'
  url 'http://www.rabbitmq.com/releases/rabbitmq-server/v2.8.1/rabbitmq-server-generic-unix-2.8.1.tar.gz'
  md5 '9ffd1f4c9bd9be40df05186144484b69'

  depends_on 'erlang'
  depends_on 'simplejson' => :python if MacOS.leopard?

  def install
    target_dir = "#{lib}/rabbitmq/#{version}"

    # Install the base files
    prefix.install Dir['*']

    # Install the config files
    (etc+'rabbitmq').mkpath
    (etc+'rabbitmq').install Dir['etc']

    # Setup the lib files
    (var+'lib/rabbitmq').mkpath
    (var+'log/rabbitmq').mkpath

    # Copy the bin, share, sbin files
    bin.install Dir['bin']
    sbin.install Dir['sbin']
    share.install Dir['share']

    # Replace the SYS_PREFIX for things like rabbitmq-plugins
    inreplace (sbin + 'rabbitmq-defaults'), 'SYS_PREFIX=${RABBITMQ_HOME}', "SYS_PREFIX=#{HOMEBREW_PREFIX}"

    # Set the RABBITMQ_HOME in rabbitmq-env
    inreplace (sbin + 'rabbitmq-env'), 'RABBITMQ_HOME="${SCRIPT_DIR}/.."', "RABBITMQ_HOME=#{prefix}"

    # Create the rabbitmq-env.conf file
    File.open("#{etc}/rabbitmq/rabbitmq-env.conf", "w") do |f|
      f.write("CONFIG_FILE=#{etc}/rabbitmq/rabbitmq\n")
      f.write("NODE_IP_ADDRESS=127.0.0.1\n")
      f.write("NODENAME=rabbit@localhost\n")
    end
    
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

__END__
