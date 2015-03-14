class Kafka < Formula
  homepage "https://kafka.apache.org"
  head "https://git-wip-us.apache.org/repos/asf/kafka.git"
  url "http://mirrors.ibiblio.org/apache/kafka/0.8.2.0/kafka-0.8.2.0-src.tgz"
  mirror "https://archive.apache.org/dist/kafka/0.8.2.0/kafka-0.8.2.0-src.tgz"
  sha1 "d2c35b60a2f534fb552030dcc7855d13292b2414"

  bottle do
    cellar :any
    sha1 "48b13bd07ff2783cc2470bb7ef212b30bb902645" => :yosemite
    sha1 "6195e7875cb9d1c071a470f19947b1f8e54ad9cd" => :mavericks
    sha1 "eb259c314ce7783327b7a7acc8fccb6b221bf529" => :mountain_lion
  end

  depends_on "gradle"
  depends_on "zookeeper"
  depends_on :java => "1.7+"

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
