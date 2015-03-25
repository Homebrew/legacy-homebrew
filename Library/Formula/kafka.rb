class Kafka < Formula
  homepage "https://kafka.apache.org"
  head "https://git-wip-us.apache.org/repos/asf/kafka.git"
  url "http://mirrors.ibiblio.org/apache/kafka/0.8.2.1/kafka-0.8.2.1-src.tgz"
  mirror "https://archive.apache.org/dist/kafka/0.8.2.1/kafka-0.8.2.1-src.tgz"
  sha1 "99d61c6e23cb2694112f844afedb6f13d711c356"

  bottle do
    cellar :any
    sha256 "60bfdd340ab233ebff0a3237fe40233c8a3be01592e2ba55af3706df2b4384f5" => :yosemite
    sha256 "1f8445794584363b89829b4d416e97f3489ddac6e276f920a624ec4c2245582f" => :mavericks
    sha256 "9034bdbbb31fdfe62b8fa9f898ad827cfdd18d72a2b9830b67867b419a210914" => :mountain_lion
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
end
