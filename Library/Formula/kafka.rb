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

    # Use 1 partition by default so individual consumers receive all topic messages
    inreplace "config/server.properties", "num.partitions=2", "num.partitions=1"

    logs = var/"log/kafka"
    logs.mkpath
    inreplace ["config/log4j.properties", "config/test-log4j.properties"],
      ".File=logs/", ".File=#{logs}/"

    data = var/"lib"
    inreplace "config/server.properties",
      "log.dirs=/tmp/kafka-logs", "log.dirs=#{data}/kafka-logs"

    inreplace "config/zookeeper.properties",
      "dataDir=/tmp/zookeeper", "dataDir=#{data}/zookeeper"

    libexec.install %w(contrib core examples lib perf project
                       system_test)

    prefix.install "bin"
    bin.env_script_all_files(libexec/"bin", :JAVA_HOME => "`/usr/libexec/java_home`")

    (etc/"kafka").install Dir["config/*"]
    libexec.install_symlink etc/"kafka" => "config"
  end

  def caveats; <<-EOS.undent
    To start Kafka, ensure that ZooKeeper is running and then execute:
      kafka-server-start.sh #{etc}/kafka/server.properties
    EOS
  end
end
