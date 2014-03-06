require "formula"

class Kafka < Formula
  homepage "http://kafka.apache.org"
  head "http://git-wip-us.apache.org/repos/asf/kafka.git"
  url "http://download.nextag.com/apache/kafka/0.8.0/kafka-0.8.0-src.tgz"
  sha1 "051e72b9ed9c3342c4e1210ffa9a9f4364171f26"

  depends_on "sbt"
  depends_on "zookeeper"

  def install
    system "sbt", "update"
    system "sbt", "package"
    system "sbt", "assembly-package-dependency"

    # Change default partition count to 1
    inreplace "config/server.properties", "num.partitions=2", "num.partitions=1"

    # Store logs in var/log/kafka
    logs = var/'log/kafka'
    logs.mkpath
    ["config/log4j.properties", "config/test-log4j.properties"].each do |f| 
      inreplace f,
        "log4j.appender.kafkaAppender.File=logs/server.log",
        "log4j.appender.kafkaAppender.File=#{logs}/server.log"

      inreplace f,
        "log4j.appender.stateChangeAppender.File=logs/state-change.log",
        "log4j.appender.stateChangeAppender.File=#{logs}/state-change.log"

      inreplace f,
        "log4j.appender.requestAppender.File=logs/kafka-request.log",
        "log4j.appender.requestAppender.File=#{logs}/kafka-request.log"

      inreplace f,
        "log4j.appender.controllerAppender.File=logs/controller.log",
        "log4j.appender.controllerAppender.File=#{logs}/controller.log"
    end

    # Store data in var/lib
    data = var/'lib'
    inreplace "config/server.properties",
      "log.dirs=/tmp/kafka-logs", "log.dirs=#{data}/kafka-logs"

    inreplace "config/zookeeper.properties",
      "dataDir=/tmp/zookeeper", "dataDir=#{data}/zookeeper"

    # Install application
    libexec.install %w(bin config contrib core examples lib perf project
                       system_test)
    bin.write_exec_script Dir["#{libexec}/bin/*"]

    # Symlink configuration files
    (etc+'kafka').mkpath
    (etc/'kafka').install_symlink Dir["#{libexec}/config/*"]
  end

  def caveats; <<-EOS.undent
    Kafka requires JAVA_HOME to be set:
      export JAVA_HOME=`/usr/libexec/java_home`
    To start Kafka, ensure that ZooKeeper is running and then execute:
      kafka-server-start.sh #{etc}/kafka/server.properties
    EOS
  end
end
