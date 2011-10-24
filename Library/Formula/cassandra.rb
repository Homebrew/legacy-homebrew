require 'formula'

class Cassandra < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=/cassandra/1.0.0/apache-cassandra-1.0.0-bin.tar.gz'
  homepage 'http://cassandra.apache.org'
  md5 '24c38152c6b44d4f056188870863c4df'

  def install
    (var+"lib/cassandra").mkpath
    (var+"log/cassandra").mkpath
    (etc+"cassandra").mkpath

    inreplace "conf/cassandra.yaml", "/var/lib/cassandra", "#{var}/lib/cassandra"
    inreplace "conf/log4j-server.properties", "/var/log/cassandra", "#{var}/log/cassandra"

    inreplace "conf/cassandra-env.sh" do |s|
      s.gsub! "/lib/", "/"
    end

    inreplace "bin/cassandra.in.sh" do |s|
      s.gsub! "CASSANDRA_HOME=`dirname $0`/..", "CASSANDRA_HOME=#{prefix}"
      # Store configs in etc, outside of keg
      s.gsub! "CASSANDRA_CONF=$CASSANDRA_HOME/conf", "CASSANDRA_CONF=#{etc}/cassandra"
      # Jars installed to prefix, no longer in a lib folder
      s.gsub! "$CASSANDRA_HOME/lib/*.jar", "$CASSANDRA_HOME/*.jar"
    end

    rm Dir["bin/*.bat"]

    (etc+"cassandra").install Dir["conf/*"]
    prefix.install Dir["*.txt"] + Dir["{bin,interface,javadoc,lib/licenses}"]
    prefix.install Dir["lib/*.jar"]

    (prefix+'org.apache.cassandra.plist').write startup_plist
    (prefix+'org.apache.cassandra.plist').chmod 0644
  end

  def caveats; <<-EOS.undent
    If this is your first install, automatically load on login with:
      mkdir -p ~/Library/LaunchAgents
      cp #{prefix}/org.apache.cassandra.plist ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/org.apache.cassandra.plist
    EOS
  end

  def startup_plist; <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>KeepAlive</key>
    <true/>

    <key>Label</key>
    <string>org.apache.cassandra</string>

    <key>ProgramArguments</key>
    <array>
        <string>#{bin}/cassandra</string>
        <string>-f</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>WorkingDirectory</key>
    <string>#{var}/lib/cassandra</string>
  </dict>
</plist>
    EOPLIST
  end
end
