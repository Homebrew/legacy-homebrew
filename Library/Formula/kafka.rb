require "formula"

class Kafka < Formula
  homepage "http://kafka.apache.org"
  head "http://git-wip-us.apache.org/repos/asf/kafka.git"
  url "http://download.nextag.com/apache/kafka/0.8.0/kafka-0.8.0-src.tgz"
  sha1 "051e72b9ed9c3342c4e1210ffa9a9f4364171f26"

  depends_on "sbt"

  def install
    system "sbt", "update"
    system "sbt", "package"
    system "sbt", "assembly-package-dependency"

    libexec.install %w(bin config contrib core examples lib perf project system_test)
    bin.write_exec_script Dir["#{libexec}/bin/*"]
    prefix.install_symlink "#{libexec}/config"
  end

  def caveats; <<-EOS.undent
    Kafka requires JAVA_HOME to be set:
      export JAVA_HOME=`/usr/libexec/java_home`
    To start Kafka:
      zookeeper-server-start.sh #{prefix}/config/zookeeper.properties
      kafka-server-start.sh #{prefix}/config/server.properties
    EOS
  end
end
