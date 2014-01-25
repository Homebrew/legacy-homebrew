require "formula"

class Kafka < Formula

  homepage "http://kafka.apache.org"
  url "http://www.apache.org/dyn/closer.cgi?path=/kafka/0.8.0/kafka_2.8.0-0.8.0.tar.gz"
  sha1 "65175b5c854cebb1276b9b062898d2a4d9c297b7"

  def default_log4j_properties
      <<-EOS.undent
        log4j.rootCategory=WARN, kafka
        log4j.appender.kafka = org.apache.log4j.FileAppender
        log4j.appender.kafka.File = #{var}/log/kafka/kafka.log
        log4j.appender.kafka.Append = true
        log4j.appender.kafka.layout = org.apache.log4j.PatternLayout
        log4j.appender.kafka.layout.ConversionPattern = %d{yyyy-MM-dd HH:mm:ss} %c{1} [%p] %m%n
      EOS
  end

  def default_log4jzk_properties
      <<-EOS.undent
        log4j.rootCategory=WARN, zkLog
        log4j.appender.zkLog = org.apache.log4j.FileAppender
        log4j.appender.zkLog.File = #{var}/log/kafka/zookeeper.log
        log4j.appender.zkLog.Append = true
        log4j.appender.zkLog.layout = org.apache.log4j.PatternLayout
        log4j.appender.zkLog.layout.ConversionPattern = %d{yyyy-MM-dd HH:mm:ss} %c{1} [%p] %m%n
      EOS
  end

  def install
    # remove windows files
    rm_rf Dir['bin/windows']


    # Create necessair destination directories
    (etc+'kafka').mkpath
    (var+'log/kafka').mkpath
    (var+'run/kafka/kafka-logs').mkpath

    prefix.install %w{ NOTICE LICENSE}

    # install default config files
    unless (etc/'kafka/zookeeper.properties').exist?
      (etc/'kafka').install 'config/zookeeper.properties'
    end

    # install default config files
    unless (etc/'kafka/server.properties').exist?
      inreplace 'config/server.properties',
      /^log.dirs=.*/, "log.dirs=#{var}/run/kafka/kafka-logs"
      (etc/'kafka').install 'config/server.properties'
    end

    unless (etc/'kafka/log4j.properties').exist?
      (etc/'kafka/log4j.properties').write(default_log4j_properties)
    end

    unless (etc/'kafka/log4jzk.properties').exist?
      (etc/'kafka/log4jzk.properties').write(default_log4jzk_properties)
    end


    # patch the base run script
    inreplace 'bin/kafka-run-class.sh' do |f|
      f.gsub! /^base_dir=.*/, "base_dir=#{libexec}/"
      f.gsub! /^LOG_DIR=.*/, "LOG_DIR=#{var}/log/kafka"
    end

    inreplace 'bin/kafka-server-start.sh' do |f|
      f.gsub! /export KAFKA_LOG4J_OPTS=.*/, "export KAFKA_LOG4J_OPTS=-Dlog4j.configuration=file://#{etc}/kafka/log4j.properties"
    end

    inreplace 'bin/zookeeper-server-start.sh' do |f|
      f.gsub! /export KAFKA_LOG4J_OPTS=.*/, "export KAFKA_LOG4J_OPTS=-Dlog4j.configuration=file://#{etc}/kafka/log4jzk.properties"
    end

    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
