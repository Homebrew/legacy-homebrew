class Hbase < Formula
  desc "Hadoop database: a distributed, scalable, big data store"
  homepage "https://hbase.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=hbase/1.1.2/hbase-1.1.2-bin.tar.gz"
  sha256 "8ca5bf0203cef86b4a0acbba89afcd5977488ebc73eec097e93c592b16f8bede"

  depends_on :java => "1.6+"
  depends_on "hadoop" => :optional
  depends_on "lzo" => :recommended
  depends_on "ant" => :build if build.with? "lzo"

  resource "hadoop-lzo" do
    url "https://github.com/cloudera/hadoop-lzo/archive/0.4.14.tar.gz"
    sha256 "aa8ddbb8b3f9e1c4b8cc3523486acdb7841cd97c002a9f2959c5b320c7bb0e6c"
  end

  def install
    ENV.java_cache if build.with? "lzo"
    rm_f Dir["bin/*.cmd", "conf/*.cmd"]
    libexec.install %w[bin conf docs lib hbase-webapps]
    bin.write_exec_script Dir["#{libexec}/bin/*"]

    if build.with? "lzo"
      resource("hadoop-lzo").stage do
        # Fixed upstream: https://github.com/cloudera/hadoop-lzo/blob/master/build.xml#L235
        inreplace "build.xml",
                  %r{(<class name="com.hadoop.compression.lzo.LzoDecompressor" />)},
                  "\\1\n<classpath refid=\"classpath\"/>"
        ENV["CLASSPATH"] = Dir["#{libexec}/lib/hadoop-common-*.jar"].first
        ENV["CFLAGS"] = "-m64"
        ENV["CXXFLAGS"] = "-m64"
        ENV["CPPFLAGS"] = "-I/System/Library/Frameworks/JavaVM.framework/Versions/Current/Headers"
        system "ant", "compile-native", "tar"
        (libexec/"lib").install Dir["build/hadoop-lzo-*/hadoop-lzo-*.jar"]
        (libexec/"lib/native").install Dir["build/hadoop-lzo-*/lib/native/*"]
      end
    end

    inreplace "#{libexec}/conf/hbase-env.sh" do |s|
      # upstream bugs for ipv6 incompatibility:
      # https://issues.apache.org/jira/browse/HADOOP-8568
      # https://issues.apache.org/jira/browse/HADOOP-3619
      s.gsub!("export HBASE_OPTS=\"-XX:+UseConcMarkSweepGC\"",
              "export HBASE_OPTS=\"-Djava.net.preferIPv4Stack=true -XX:+UseConcMarkSweepGC\"")
      s.gsub!("# export JAVA_HOME=/usr/java/jdk1.6.0/",
              "export JAVA_HOME=\"$(/usr/libexec/java_home)\"")
    end

    inreplace "#{libexec}/conf/hbase-site.xml",
      # makes hbase usable out of the box
      # upstream has been provided this patch
      # https://issues.apache.org/jira/browse/HBASE-15426
      /<configuration>/,
      <<-EOS.undent
      <configuration>
        <property>
          <name>hbase.rootdir</name>
          <value>#{(build.with? "hadoop") ? "hdfs://localhost:9000" : "file://"+var}/hbase</value>
        </property>
        <property>
          <name>hbase.zookeeper.property.clientPort</name>
          <value>2181</value>
        </property>
        <property>
          <name>hbase.zookeeper.property.dataDir</name>
          <value>#{var}/zookeeper</value>
        </property>
        <property>
          <name>hbase.zookeeper.dns.interface</name>
          <value>lo0</value>
        </property>
        <property>
          <name>hbase.regionserver.dns.interface</name>
          <value>lo0</value>
        </property>
        <property>
          <name>hbase.master.dns.interface</name>
          <value>lo0</value>
        </property>
      EOS

    (var/"run/hbase").mkpath
    (libexec/"logs").mkpath
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/hbase/bin/start-hbase.sh"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      #{(build.without? "hadoop") ? "<true/>" : "<dict>\n        <key>OtherJobEnabled</key>\n        <string>"+Formula["hadoop"].plist_name+"</string>\n      </dict>"}
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>EnvironmentVariables</key>
      <dict>
       <key>HBASE_MASTER_OPTS</key><string> -XX:PermSize=128m -XX:MaxPermSize=128m</string>
       <key>HBASE_LOG_DIR</key><string>#{var}/hbase</string>
       <key>HBASE_HOME</key><string>#{opt_libexec}</string>
       <key>HBASE_SECURITY_LOGGER</key><string>INFO,RFAS</string>
       <key>HBASE_PID_DIR</key><string>#{var}/run/hbase</string>
       <key>HBASE_NICENESS</key><string>0</string>
       <key>HBASE_IDENT_STRING</key><string>root</string>
       <key>HBASE_REGIONSERVER_OPTS</key><string> -XX:PermSize=128m -XX:MaxPermSize=128m</string>
       <key>HBASE_OPTS</key><string>-XX:+UseConcMarkSweepGC</string>
       <key>HBASE_ROOT_LOGGER</key><string>INFO,RFA</string>
       <key>HBASE_LOG_PREFIX</key><string>hbase-root-master</string>
       <key>HBASE_LOGFILE</key><string>hbase-root-master.log</string>
      </dict>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/hbase</string>
        <string>--config</string>
        <string>#{opt_libexec}/conf</string>
        <string>master</string>
        <string>start</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardOutPath</key>
      <string>#{var}/hbase/hbase.log</string>
      <key>StandardErrorPath</key>
      <string>#{var}/hbase/hbase.err</string>
    </dict>
    </plist>
    EOS
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/hbase mapredcp")

    cp_r (libexec/"conf"), testpath
    inreplace (testpath/"conf/hbase-site.xml") do |s|
      s.gsub! /(hbase.rootdir.*)\n.*/, "\\1\n<value>file://#{testpath}/hbase</value>"
      s.gsub! /(hbase.zookeeper.property.dataDir.*)\n.*/, "\\1\n<value>#{testpath}/zookeeper</value>"
    end

    ENV["HBASE_LOG_DIR"]  = (testpath/"logs")
    ENV["HBASE_CONF_DIR"] = (testpath/"conf")
    ENV["HBASE_PID_DIR"]  = (testpath/"pid")

    system "#{bin}/start-hbase.sh"
    assert_match /Zookeeper/, pipe_output("nc 127.0.0.1 2181 2>&1", "stats")
    system "#{bin}/stop-hbase.sh"
  end
end
