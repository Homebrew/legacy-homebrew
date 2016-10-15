require 'formula'

class Kafka < Formula
  homepage 'http://kafka.apache.org/'
  head 'http://git-wip-us.apache.org/repos/asf/kafka.git'
  url 'http://www.apache.org/dyn/closer.cgi?path=kafka/0.8.0/kafka-0.8.0-src.tgz'
  sha1 '051e72b9ed9c3342c4e1210ffa9a9f4364171f26'

  def install
    system "./sbt", "update"
    system "./sbt", "+package"
    system "./sbt", "assembly-package-dependency"
    libexec.install %w[bin]

    prefix.install 'config', 'contrib', 'core', 'examples', 'perf', 'contrib'
    libexec.install Dir['project/target/scala-*/*.jar']
    libexec.install Dir['*.jar']
    libexec.install Dir['lib/*']

    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    Kafka requires JAVA_HOME to be set:
      export JAVA_HOME=$(/usr/libexec/java_home)
    
    To start Kafka:
      zookeeper-server-start.sh #{prefix}/config/zookeeper.properties
      kafka-server-start.sh #{prefix}/config/server.properties
    EOS
  end
end
