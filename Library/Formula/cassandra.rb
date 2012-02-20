require 'formula'

class Cassandra < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=/cassandra/1.0.7/apache-cassandra-1.0.7-bin.tar.gz'
  homepage 'http://cassandra.apache.org'
  sha1 '8ae535821b29eead5b7dc7788a0e66ecf1ac267e'

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
    prefix.install Dir["*.txt"] + Dir["{bin,interface,javadoc,pylib,lib/licenses}"]
    prefix.install Dir["lib/*.jar"]

    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def patches
    # let cqlsh know where to find cqlshlib
    DATA
  end

  def caveats; <<-EOS.undent
    If this is your first install, automatically load on login with:
      mkdir -p ~/Library/LaunchAgents
      cp #{plist_path} ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    If you plan to use the CQL shell (cqlsh), you will need the Python CQL library
    installed. Since Homebrew prefers using pip for Python packages, you can
    install that using:

      pip install cql

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
    <string>#{plist_name}</string>

    <key>ProgramArguments</key>
    <array>
        <string>#{HOMEBREW_PREFIX}/bin/cassandra</string>
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

__END__
diff --git a/bin/cqlsh b/bin/cqlsh
index 0f02a0c..f7fb469 100755
--- a/bin/cqlsh
+++ b/bin/cqlsh
@@ -47,7 +47,7 @@ import ConfigParser
 
 # cqlsh should run correctly when run out of a Cassandra source tree,
 # out of an unpacked Cassandra tarball, and after a proper package install.
-cqlshlibdir = os.path.join(os.path.dirname(__file__), '..', 'pylib')
+cqlshlibdir = os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'pylib')
 if os.path.isdir(cqlshlibdir):
     sys.path.insert(0, cqlshlibdir)
 
