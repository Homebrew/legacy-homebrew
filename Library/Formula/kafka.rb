class Kafka < Formula
  desc "Publish-subscribe messaging rethought as a distributed commit log"
  homepage "https://kafka.apache.org"
  head "https://git-wip-us.apache.org/repos/asf/kafka.git"
  url "http://mirrors.ibiblio.org/apache/kafka/0.8.2.1/kafka-0.8.2.1-src.tgz"
  mirror "https://archive.apache.org/dist/kafka/0.8.2.1/kafka-0.8.2.1-src.tgz"
  sha256 "a043655be6f3b6ec3f7eea25cc6525fd582da825972d3589b24912af71493a21"

  bottle do
    cellar :any
    revision 1
    sha256 "6421db989eae488bbd6491f22ced46753500cb3534f0dec47b2f2132afa4425d" => :yosemite
    sha256 "4adacd36a38bbef07e4326224d56c74cdc34b906ec60594035f4c354aa25381e" => :mavericks
    sha256 "63fca4b6a35aaa7c50771d93ffca044c1cbe6ae66f6b76617408533b40ff8687" => :mountain_lion
  end

  depends_on "gradle"
  depends_on "zookeeper"
  depends_on :java => "1.7+"

  # Related to https://issues.apache.org/jira/browse/KAFKA-2034
  # Since Kafka does not currently set the source or target compability version inside build.gradle
  # if you do not have Java 1.8 installed you cannot used the bottled version of Kafka
  def pour_bottle?
    quiet_system("/usr/libexec/java_home --version 1.8 --failfast")
  end

  def install
    system "gradle"
    system "gradle", "jar"

    logs = var/"log/kafka"
    inreplace "config/log4j.properties", "kafka.logs.dir=logs", "kafka.logs.dir=#{logs}"
    inreplace "config/test-log4j.properties", ".File=logs/", ".File=#{logs}/"

    data = var/"lib"
    inreplace "config/server.properties",
      "log.dirs=/tmp/kafka-logs", "log.dirs=#{data}/kafka-logs"

    inreplace "config/zookeeper.properties",
      "dataDir=/tmp/zookeeper", "dataDir=#{data}/zookeeper"

    # Workaround for conflicting slf4j-log4j12 jars (1.7.6 is preferred)
    rm_f "core/build/dependant-libs-2.10.4/slf4j-log4j12-1.6.1.jar"

    # remove Windows scripts
    rm_rf "bin/windows"

    libexec.install %w[clients contrib core examples system_test]

    prefix.install "bin"
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.7+"))

    mv "config", "kafka"
    etc.install "kafka"
    libexec.install_symlink etc/"kafka" => "config"

    # create directory for kafka stdout+stderr output logs when run by launchd
    (var+"log/kafka").mkpath
  end

  def caveats; <<-EOS.undent
    To start Kafka, ensure that ZooKeeper is running and then execute:
      kafka-server-start.sh #{etc}/kafka/server.properties
    EOS
  end

  test do
    cp_r libexec/"system_test", testpath
    cd testpath/"system_test" do
      # skip plot graph if matplotlib is unavailable.
      # https://github.com/Homebrew/homebrew/pull/37264#issuecomment-76514574
      unless quiet_system "python", "-c", "import matplotlib"
        inreplace testpath/"system_test/utils/metrics.py" do |s|
          s.gsub! "import matplotlib as mpl", ""
          s.gsub! "mpl.use('Agg')", ""
          s.gsub! "import matplotlib.pyplot as plt", ""
          s.gsub! "import numpy", ""
          s.gsub! "if not inputCsvFiles: return", "return"
        end
      end
      system "./run_sanity.sh"
    end
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/kafka-server-start.sh</string>
            <string>#{etc}/kafka/server.properties</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/kafka/kafka_output.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/kafka/kafka_output.log</string>
    </dict>
    </plist>
    EOS
  end
end
