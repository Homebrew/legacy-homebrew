class Kafka < Formula
  homepage "https://kafka.apache.org"
  desc "Publish-subscribe messaging rethought as a distributed commit log"
  url "http://mirrors.ibiblio.org/apache/kafka/0.9.0.0/kafka-0.9.0.0-src.tgz"
  mirror "https://archive.apache.org/dist/kafka/0.9.0.0/kafka-0.9.0.0-src.tgz"
  sha256 "642316ddcd87d0b972c876b6d47cf286aa393e6a8427bc1e77a718047a364046"

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
    inreplace "config/test-log4j.properties", ".File=logs/", ".File=#{logs}/"

    data = var/"lib"
    inreplace "config/server.properties",
      "log.dirs=/tmp/kafka-logs", "log.dirs=#{data}/kafka-logs"

    inreplace "config/zookeeper.properties",
      "dataDir=/tmp/zookeeper", "dataDir=#{data}/zookeeper"

    # Workaround for conflicting slf4j-log4j12 jars (1.7.10 is preferred)
    rm_f "core/build/dependant-libs-2.10.5/slf4j-log4j12-1.7.6.jar"

    # remove Windows scripts
    rm_rf "bin/windows"

    libexec.install %w[clients core examples]

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
      kafka-server-start.sh -daemon #{etc}/kafka/server.properties
    EOS
  end

  test do
    # This is far from an ideal test, but this is the best we can do, because for whatever reason
    # the test below will not run in Travis 10.9, however will run successfully on any other 10.9 machine
    # Likewise, the software runs just fine on 10.9.
    ohai "Ensuring the Kafka 0.9.0.0 JAR exists in the right place"
    assert File.exists? libexec/"core/build/libs/kafka_2.10-0.9.0.0.jar"

    # ====== leaving this in, in case someone can get it to work on mavericks
    #
    # A REALLY bad test... however Kafka doesn't say its version anywhere so its the best we can do.
    # Furthermore, we can't just start and stop a ZK and Kafka instance, as theyd need to daemonize, and
    # in order to daemonize, they need to write access to a place where they expect to put their PID file
    # but that's impossible inside the sandbox.
    #
    # The ZooKeeper client that Kafka uses spits out some key JVM parameters when it is first initialized,
    # namely "java.class.path", which gets set by kafka-run-class.sh, which is called by kafka-server-start.sh
    # Thus, a correct java.class.path implies that the correct version of Kafka has been installed and is running when
    # the command to start are invoked and the fact that it runs to begin with indicates that the
    # prerequisites for successful environment to run in are met.
    #
    # We simply check that the classpath has the JAR of the Kafka version we want to use. But first, we need to
    # set a few environment variables that kafka-run-class.sh uses for things like figuring out where
    # to save logs. We need to do this so that Kafka doesnt try to write log files into
    # /usr/local/Cellar/kafka/version/blahblah and instead into the sandbox's temporary directory, because otherwise
    # instead of lovely ZooKeeper client debug messages, we just get a bunch of "operation not permitted" IO errors
    # and Kafka will crash (or worse, livelock) before the ZK client has a chance to start and work its magic.
    #
    # ohai "Checking that the correct JAR (kafka_2.10.0-0.9.0.0.jar) is being loaded by kafka-run-class.sh"
    #
    # require 'open3'
    # Open3.popen3("LOG_DIR=#{testpath}/kafkalog kafka-server-start.sh #{etc}/kafka/server.properties --override zookeeper.connect=localhost:-1") do |_, stdout, _, _|
    #   assert_match /.*environment:java\.class\.path.*kafka_2\.10-0\.9\.0\.0\.jar.*/, stdout.read
    # end
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
