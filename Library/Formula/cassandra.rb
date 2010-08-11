require 'formula'

class Cassandra <Formula
  url 'http://www.alliedquotes.com/mirrors/apache/cassandra/0.6.4/apache-cassandra-0.6.4-bin.tar.gz'
  homepage 'http://cassandra.apache.org'
  md5 '3bb41737ef8f1f76cd5d13cb6db5e079'

  def install
    (var+"lib/cassandra").mkpath
    (var+"log/cassandra").mkpath
    (etc+"cassandra").mkpath

    inreplace "conf/storage-conf.xml", "/var/lib/cassandra", "#{var}/lib/cassandra"
    inreplace "conf/log4j.properties", "/var/log/cassandra", "#{var}/log/cassandra"

    inreplace "bin/cassandra.in.sh" do |s|
      s.gsub! "cassandra_home=`dirname $0`/..", "cassandra_home=#{prefix}"
      # Store configs in etc, outside of keg
      s.gsub! "CASSANDRA_CONF=$cassandra_home/conf", "CASSANDRA_CONF=#{etc}/cassandra"
      # Jars installed to prefix, no longer in a lib folder
      s.gsub! "$cassandra_home/lib/*.jar", "$cassandra_home/*.jar"
    end

    rm Dir["bin/*.bat"]

    (etc+"cassandra").install Dir["conf/*"]
    prefix.install Dir["*.txt"] + Dir["{bin,interface,javadoc}"]
    prefix.install Dir["lib/*.jar"]
  end
end