require 'formula'

class Cassandra < Formula
  url 'http://mirrors.ibiblio.org/apache//cassandra/0.8.0/apache-cassandra-0.8.0-bin.tar.gz'
  homepage 'http://cassandra.apache.org'
  md5 'ea97a815c3ee8c08ad408eb075f495cf'

  def install
    (var+"lib/cassandra").mkpath
    (var+"log/cassandra").mkpath
    (etc+"cassandra").mkpath

    inreplace "conf/cassandra.yaml", "/var/lib/cassandra", "#{var}/lib/cassandra"
    inreplace "conf/log4j-server.properties", "/var/log/cassandra", "#{var}/log/cassandra"

    inreplace "bin/cassandra.in.sh" do |s|
      s.gsub! "CASSANDRA_HOME=`dirname $0`/..", "CASSANDRA_HOME=#{prefix}"
      # Store configs in etc, outside of keg
      s.gsub! "CASSANDRA_CONF=$CASSANDRA_HOME/conf", "CASSANDRA_CONF=#{etc}/cassandra"
      # Jars installed to prefix, no longer in a lib folder
      s.gsub! "$CASSANDRA_HOME/lib/*.jar", "$CASSANDRA_HOME/*.jar"
    end

    rm Dir["bin/*.bat"]

    (etc+"cassandra").install Dir["conf/*"]
    prefix.install Dir["*.txt"] + Dir["{bin,interface,javadoc}"]
    prefix.install Dir["lib/*.jar"]
  end

  def caveats
    <<-EOS.undent
      To view a summary of the changes for this version of Cassandra, please see:
      https://svn.apache.org/viewvc/cassandra/branches/cassandra-0.8.0/NEWS.txt?revision=1129278&view=co
    EOS
  end
end
