require 'formula'

class Rabbitmq < Formula
  homepage 'http://rabbitmq.com'
  url 'http://www.rabbitmq.com/releases/rabbitmq-server/v2.5.1/rabbitmq-server-2.5.1.tar.gz'
  md5 '51295dfd10661ea0db99d9a22ae4445d'

  depends_on 'erlang'
  depends_on 'simplejson' => :python if MacOS.leopard?

  def options
    [
      ['--plugins', "Install all standard RabbitMQ plugins"],
      ['--experimental-plugins', "Install all experimental RabbitMQ plugins"],
    ]
  end

  def install
    # Building the manual requires additional software, so skip it.
    inreplace "Makefile", "install: install_bin install_docs", "install: install_bin"

    target_dir = "#{lib}/rabbitmq/erlang/lib/rabbitmq-#{version}"
    system "make"
    ENV['TARGET_DIR'] = target_dir
    ENV['MAN_DIR'] = man
    ENV['SBIN_DIR'] = sbin
    ENV['PLUGIN_DIR'] =  "#{lib}/rabbitmq/erlang/lib/rabbitmq-#{version}/plugins/"
    ENV['RABBITMQ_VERSION'] = version
    system "make install"

    ln_s  "#{lib}/rabbitmq/erlang/lib/rabbitmq-#{version}/plugins", prefix

    (etc+'rabbitmq').mkpath
    (var+'lib/rabbitmq').mkpath
    (var+'log/rabbitmq').mkpath

    %w{rabbitmq-server rabbitmqctl rabbitmq-env}.each do |script|
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

    if ARGV.include? '--plugins'
      Amqp_client.new.brew {}
      Eldap.new.brew {}
      Rabbitmq_auth_backend_ldap.new.brew {}
      Rabbitmq_auth_mechanism_ssl.new.brew {}
      Rabbitmq_shovel.new.brew {}
      Rabbitmq_stomp.new.brew {}
      Webmachine.new.brew {}
      Mochiweb.new.brew {}
      Rabbitmq_management.new.brew {}
      Rabbitmq_management_agent.new.brew {}
      Rabbitmq_mochiweb.new.brew {}
    end

    if ARGV.include? '--experimental-plugins'
      Amqp_client.new.brew {}
      Rfc4627_jsonrpc.new.brew {}
      Rabbitmq_jsonrpc.new.brew {}
      Rabbitmq_jsonrpc_channel.new.brew {}
      Rabbitmq_jsonrpc_channel_examples.new.brew {}
    end
  end


  def caveats
    s = <<-EOS.undent
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

    if ARGV.include? '--plugins'
      s += <<-EOS.undent
        All standard plugins have been installed. This includes the following:

          rabbitmq_auth_mechanism_ssl
          rabbitmq_auth_backend_ldap and requirements
          rabbitmq_management and requirements
          rabbitmq_management_agent
          rabbitmq_shovel
          rabbitmq_stomp

        To deactivate a plugin remove it and any dependency .ez files from the
        "#{prefix}/plugins/" directory.

        The rabbitmq_management plugin by default listens on http://0.0.0.0:55672

        For more information on the installed plugins, see http://www.rabbitmq.com/plugins.html

      EOS
    end

    if ARGV.include? '--experimental-plugins'
      s += <<-EOS.undent
        The experimental plugins have been installed. This currently includes the
        rabbitmq-jsonrpc-channel plugin and it's examples. If you do not want to run with
        the examples live on your server, remove the rabbitmq_jsonrpc_channel_examples-#{version}.ez
        file from the "#{prefix}/plugins/" directory

        The rabbitmq-jsonrpc-channel plugin by default listens on http://0.0.0.0:55672

        For more information on the installed plugins, see http://www.rabbitmq.com/plugins.html

      EOS
    end
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


class PluginDownloadStrategy < CurlDownloadStrategy
  def stage
    FileUtils.cp @tarball_path, ENV['PLUGIN_DIR']
  end
end

class PluginFormula < Formula
  def initialize name='__UNKNOWN__', path=nil
    super name, path
    @version = ENV['RABBITMQ_VERSION']
  end
  def download_strategy
    return PluginDownloadStrategy
  end
end
class Rabbitmq_stomp < PluginFormula
  url 'http://www.rabbitmq.com/releases/plugins/v2.5.1/rabbitmq_stomp-2.5.1.ez'
  md5 '7b33abfa85b14caafb458f2e7f12bcb7'
end

class Eldap < PluginFormula
  url 'http://www.rabbitmq.com/releases/plugins/v2.5.1/eldap-2.5.1-gite309de4.ez'
  md5 '45a7acde6d24f1ded4c7a36db69314d0'
end

class Mochiweb < PluginFormula
  url 'http://www.rabbitmq.com/releases/plugins/v2.5.1/mochiweb-1.3-rmq2.5.1-git9a53dbd.ez'
  md5 '07f3b87ccb1d03d479a4277014a7e017'
end

class Rabbitmq_auth_backend_ldap < PluginFormula
  url 'http://www.rabbitmq.com/releases/plugins/v2.5.1/rabbitmq_auth_backend_ldap-2.5.1.ez'
  md5 '59c3838e017f635e6263b169c4e26581'
end

class Rabbitmq_shovel < PluginFormula
  url 'http://www.rabbitmq.com/releases/plugins/v2.5.1/rabbitmq_shovel-2.5.1.ez'
  md5 '3b4f7c4da41e9bb7749ff23948fe2ed7'
end

class Webmachine < PluginFormula
  url 'http://www.rabbitmq.com/releases/plugins/v2.5.1/webmachine-1.7.0-rmq2.5.1-hg0c4b60a.ez'
  md5 '2c7fddc210317a054c97b43e13d38ced'
end

class Rfc4627_jsonrpc < PluginFormula
  url 'http://www.rabbitmq.com/releases/plugins/v2.5.1/rfc4627_jsonrpc-2.5.1-git30c8498.ez'
  md5 '65738893af3cec53c43276752822bb96'
end

class Rabbitmq_jsonrpc_channel_examples < PluginFormula
  url 'http://www.rabbitmq.com/releases/plugins/v2.5.1/rabbitmq_jsonrpc_channel_examples-2.5.1.ez'
  md5 'd822b0c70d36897b24afb67659090f0e'
end

class Rabbitmq_management < PluginFormula
  url 'http://www.rabbitmq.com/releases/plugins/v2.5.1/rabbitmq_management-2.5.1.ez'
  md5 '69aa2c17ebfff7bdf141d8df0b358631'
end

class Rabbitmq_jsonrpc < PluginFormula
  url 'http://www.rabbitmq.com/releases/plugins/v2.5.1/rabbitmq_jsonrpc-2.5.1.ez'
  md5 '5e49c7bc00cdc6bfc346dc75d309c897'
end

class Rabbitmq_jsonrpc_channel < PluginFormula
  url 'http://www.rabbitmq.com/releases/plugins/v2.5.1/rabbitmq_jsonrpc_channel-2.5.1.ez'
  md5 'e82398c82b5ffc8a6ddc10db06663786'
end

class Rabbitmq_auth_mechanism_ssl < PluginFormula
  url 'http://www.rabbitmq.com/releases/plugins/v2.5.1/rabbitmq_auth_mechanism_ssl-2.5.1.ez'
  md5 '716a86b138cf0c314971a9c6af8805dd'
end

class Rabbitmq_mochiweb < PluginFormula
  url 'http://www.rabbitmq.com/releases/plugins/v2.5.1/rabbitmq_mochiweb-2.5.1.ez'
  md5 '0cd0b60bd8b9019fd9dbea08f667a697'
end

class Amqp_client < PluginFormula
  url 'http://www.rabbitmq.com/releases/plugins/v2.5.1/amqp_client-2.5.1.ez'
  md5 '2602dd3df87fa4c7dedd6eb3192b0c19'
end

class Rabbitmq_management_agent < PluginFormula
  url 'http://www.rabbitmq.com/releases/plugins/v2.5.1/rabbitmq_management_agent-2.5.1.ez'
  md5 '4165b7d2aeeeeae9239b173b5e803c89'
end
