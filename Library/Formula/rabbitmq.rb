require 'formula'

class Rabbitmq < Formula
  homepage 'http://rabbitmq.com'
  url 'http://www.rabbitmq.com/releases/rabbitmq-server/v2.4.1/rabbitmq-server-2.4.1.tar.gz'
  md5 '6db31b4353bd44f8ae9b6756b0a831e6'

  depends_on 'erlang'
  depends_on 'simplejson' => :python if MacOS.leopard?

  def patches
    # (1) Can't build manpages without a lot of other junk, so disable
    # (2) Patch to build against Erlang R14B03 - http://old.nabble.com/RabbitMQ-and-Erlang-R14B03-td31699881.html
    #     Can be removed in next stable release.
    [
      DATA,
      "https://github.com/rabbitmq/rabbitmq-server/commit/3ab92151948c0c546cbefe5902efbd92acd14280.patch"
    ]
  end

  def install
    target_dir = "#{lib}/rabbitmq/erlang/lib/rabbitmq-#{version}"
    system "make"
    ENV['TARGET_DIR'] = target_dir
    ENV['MAN_DIR'] = man
    ENV['SBIN_DIR'] = sbin
    system "make install"

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

__END__
diff --git a/Makefile b/Makefile
index d3f052f..98ce763 100644
--- a/Makefile
+++ b/Makefile
@@ -267,7 +267,7 @@ $(SOURCE_DIR)/%_usage.erl:

 docs_all: $(MANPAGES) $(WEB_MANPAGES)

-install: install_bin install_docs
+install: install_bin

 install_bin: all install_dirs
	cp -r ebin include LICENSE LICENSE-MPL-RabbitMQ INSTALL $(TARGET_DIR)
