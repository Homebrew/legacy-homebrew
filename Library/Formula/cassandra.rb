require 'formula'

class Cassandra < Formula
  homepage 'http://cassandra.apache.org'
  url 'http://www.apache.org/dyn/closer.cgi?path=/cassandra/2.0.5/apache-cassandra-2.0.5-bin.tar.gz'
  sha1 '25602881eaf1326fddb23d02dee72787751c95f7'

  def install
    (var+"lib/cassandra").mkpath
    (var+"log/cassandra").mkpath
    (etc+"cassandra").mkpath

    inreplace "conf/cassandra.yaml", "/var/lib/cassandra", "#{var}/lib/cassandra"
    inreplace "conf/log4j-server.properties", "/var/log/cassandra", "#{var}/log/cassandra"
    inreplace "conf/cassandra-env.sh", "/lib/", "/"

    # See https://github.com/Homebrew/homebrew/issues/26795#issuecomment-35723208
    # Cassandra.in refers to lib/jamm-0.2.5.jar
    # TODO: either pack jars in ./lib or remove from JAVA_AGENT="$JAVA_AGENT -javaagent:$CASSANDRA_HOME/jamm-0.2.5.jar" path
    inreplace "bin/cassandra.in.sh" do |s|
      s.gsub! "CASSANDRA_HOME=\"`dirname \"$0\"`/..\"", "CASSANDRA_HOME=\"#{prefix}\""
      # Store configs in etc, outside of keg
      s.gsub! "CASSANDRA_CONF=\"$CASSANDRA_HOME/conf\"", "CASSANDRA_CONF=\"#{etc}/cassandra\""
      # Jars installed to prefix, no longer in a lib folder
      s.gsub! "\"$CASSANDRA_HOME\"/lib/*.jar", "\"$CASSANDRA_HOME\"/*.jar"
      # Something like this perhaps
      s.gsub "-javaagent:$CASSANDRA_HOME/lib/jamm-0.2.5.jar", "-javaagent:$CASSANDRA_HOME/jamm-0.2.5.jar"
    end

    rm Dir["bin/*.bat"]

    (etc+"cassandra").install Dir["conf/*"]
    prefix.install Dir["*.txt"] + Dir["{bin,interface,javadoc,pylib,lib/licenses}"]
    prefix.install Dir["lib/*.jar"]

    share.install [bin+'cassandra.in.sh', bin+'stop-server']
    inreplace Dir["#{bin}/cassandra*", "#{bin}/debug-cql",
                  "#{bin}/json2sstable", "#{bin}/nodetool",
                  "#{bin}/sstable*"],
      /`dirname "?\$0"?`\/cassandra.in.sh/,
      "#{share}/cassandra.in.sh"
  end

  def caveats; <<-EOS.undent
    If you plan to use the CQL shell (cqlsh), you will need the Python CQL library
    installed. Since Homebrew prefers using pip for Python packages, you can
    install that using:

      pip install cql
    EOS
  end

  def plist; <<-EOS.undent
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
            <string>#{opt_prefix}/bin/cassandra</string>
            <string>-f</string>
        </array>

        <key>RunAtLoad</key>
        <true/>

        <key>WorkingDirectory</key>
        <string>#{var}/lib/cassandra</string>
      </dict>
    </plist>
    EOS
  end
end
