class Kafka < Formula
  desc "Publish-subscribe messaging rethought as a distributed commit log"
  homepage "https://kafka.apache.org"
  url "http://mirrors.ibiblio.org/apache/kafka/0.8.2.2/kafka-0.8.2.2-src.tgz"
  mirror "https://archive.apache.org/dist/kafka/0.8.2.2/kafka-0.8.2.2-src.tgz"
  sha256 "77e9ed27c25650c07d00f380bd7c04d6345cbb984d70ddc52bbb4cb512d8b03c"

  head "https://git-wip-us.apache.org/repos/asf/kafka.git", :branch => "trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "881db94838f291a09fef3d7070c4e99865eccb16f84e8447777a65cc14e0a180" => :el_capitan
    sha256 "e07789b42a964353d49fdd4402f502c9803044e0477fcd0da6dad14b26b4c20d" => :yosemite
    sha256 "1e57ab9774f8adee9f08c941eabdc029955b6ea43c4bc109b6420e74a515f08c" => :mavericks
  end

  depends_on "gradle"
  depends_on "zookeeper"
  depends_on :java => "1.7+"

  # Related to https://issues.apache.org/jira/browse/KAFKA-2034
  # Since Kafka does not currently set the source or target compability version inside build.gradle
  # if you do not have Java 1.8 installed you cannot used the bottled version of Kafka
  pour_bottle? do
    reason "The bottle requires Java 1.8."
    satisfy { quiet_system("/usr/libexec/java_home --version 1.8 --failfast") }
  end

  def install
    ENV.java_cache

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
