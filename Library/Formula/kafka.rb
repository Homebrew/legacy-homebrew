require "formula"

class Kafka < Formula
  homepage "http://kafka.apache.org"
  head "http://git-wip-us.apache.org/repos/asf/kafka.git"
  url "http://mirrors.ibiblio.org/apache/kafka/0.8.2.0/kafka-0.8.2.0-src.tgz"
  mirror "http://mirror.sdunix.com/apache/kafka/0.8.2.0/kafka-0.8.2.0-src.tgz"
  sha1 "d2c35b60a2f534fb552030dcc7855d13292b2414"

  depends_on "gradle"
  depends_on "zookeeper"
  depends_on :java => "1.7"

  def install
    system "gradle", "wrapper"
    system "./gradlew", "jar"

    logs = var/"log/kafka"
    inreplace "config/log4j.properties", "kafka.logs.dir=logs", "kafka.logs.dir=#{logs}"
    inreplace "config/test-log4j.properties", ".File=logs/", ".File=#{logs}/"

    data = var/"lib"
    inreplace "config/server.properties",
      "log.dirs=/tmp/kafka-logs", "log.dirs=#{data}/kafka-logs"

    inreplace "config/zookeeper.properties",
      "dataDir=/tmp/zookeeper", "dataDir=#{data}/zookeeper"

    libexec.install %w(contrib core examples system_test)

    prefix.install "bin"
    bin.env_script_all_files(libexec/"bin", :JAVA_HOME => "`/usr/libexec/java_home`")

    mv "config", "kafka"
    etc.install "kafka"
    libexec.install_symlink etc/"kafka" => "config"
  end

  def caveats; <<-EOS.undent
    To start Kafka, ensure that ZooKeeper is running and then execute:
      kafka-server-start.sh #{etc}/kafka/server.properties

    Gradle's Scala plugin is not Java 8 compatible, so you may have to
    use Java 7, see:
      http://issues.gradle.org/browse/GRADLE-3023

    If you have Java 7 installed along with other versions, try:
      JAVA_HOME=$(/usr/libexec/java_home -v 1.7) brew install kafka
    EOS
  end

  test do
  end
end
