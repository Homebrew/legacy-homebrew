require 'formula'

class Hadoop < Formula
  homepage 'http://hadoop.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=hadoop/common/hadoop-2.4.1/hadoop-2.4.1.tar.gz'
  sha1 'bec3d911fd0b84cd4a7130fb212125c7ae51e878'

  option 'without-conf', 'Install hadoop without pre-configured files'

  def install
    conf_files = %W[
      etc/hadoop/capacity-scheduler.xml
      etc/hadoop/configuration.xsl
      etc/hadoop/hadoop-env.sh
      etc/hadoop/hadoop-policy.xml
      etc/hadoop/log4j.properties
      etc/hadoop/mapred-env.sh
      etc/hadoop/yarn-env.sh
    ]

    # Delete files for windows
    rm_f Dir['bin/*.cmd', 'sbin/*.cmd', 'libexec/*.cmd', 'etc/hadoop/*.cmd']

    # Create startup script
    (buildpath+'bin/hadoop_server').write hadoop_server
    chmod 0555, "#{buildpath}/bin/hadoop_server"

    # Create setting files if there is no old one
    if build.with? "conf"
        ohai "Creating conf files..."
        opts="\"-Djava.security.krb5.realm= -Djava.security.krb5.kdc= -Djava.security.krb5.conf=/dev/null\""
        (etc+'hadoop/core-site.xml').write core_site_xml
        (etc+'hadoop/hdfs-site.xml').write hdfs_site_xml
        (etc+'hadoop/yarn-site.xml').write yarn_site_xml
        (etc+'hadoop/mapred-site.xml').write mapred_site_xml
        (etc+'hadoop').install conf_files
        (var+'hadoop').mkpath
        inreplace "#{etc}/hadoop/hadoop-env.sh",
                  "export JAVA_HOME=${JAVA_HOME}",
                  "export JAVA_HOME=\"$(/usr/libexec/java_home)\"\nexport HADOOP_OPTS=#{opts}"
        inreplace "#{etc}/hadoop/yarn-env.sh",
                "# export JAVA_HOME=/home/y/libexec/jdk1.6.0/",
                "export JAVA_HOME=\"$(/usr/libexec/java_home)\"\nexport YARN_OPTS=#{opts}"
        inreplace "#{etc}/hadoop/mapred-env.sh",
                "# export JAVA_HOME=/home/y/libexec/jdk1.6.0/",
                "export JAVA_HOME=\"$(/usr/libexec/java_home)\""
      ohai <<-EOS.undent
      In Hadoop's config file:
           #{etc}/hadoop/*-env.sh
           $JAVA_HOME has been set to be the output of:
           /usr/libexec/java_home
      EOS
    else
      ohai "Please config hadoop settings at #{etc}/hadoop to get it working"
    end

    # Install
    (var+'log/hadoop').mkpath
    (var+'run/hadoop').mkpath
    (buildpath+'libexec/hadoop-layout.sh').write hadoop_layout_sh
    (etc+'hadoop/template').install Dir['etc/hadoop/*']
    libexec.install %w[bin sbin libexec share]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
    sbin.write_exec_script Dir["#{libexec}/sbin/*"]
    # But don't make rcc visible, it conflicts with Qt
    (bin/'rcc').unlink
    # These aren't mac executables if not compile natively
    (bin/'container-executor').unlink
    (bin/'test-container-executor').unlink


    if build.with? "conf" and !File.directory?(var+'hadoop/hdfs/name')
      ohai "Formating HDFS..."
      system "#{libexec}/bin/hdfs", 'namenode', '-format'
    end
  end

  def caveats;<<-EOS.undent
      Config files is at:
        #{etc}/hadoop/

      To start/stop:
        hadoop_server start/stop
    EOS
  end

  def hadoop_layout_sh; <<-EOS.undent
    # Set conf files path
    HADOOP_CONF_DIR=#{etc}/hadoop
    YARN_CONF_DIR=#{etc}/hadoop

    # Set log files path
    HADOOP_LOG_DIR=#{var}/log/hadoop/hdfs
    HADOOP_MAPRED_LOG_DIR=#{var}/log/hadoop/mapred
    YARN_LOG_DIR=#{var}/log/hadoop/yarn

    # Set pig files path
    HADOOP_PID_DIR=#{var}/run/hadoop/hdfs
    HADOOP_MAPRED_PID_DIR=#{var}/run/hadoop/mapred
    YARN_PID_DIR=#{var}/run/hadoop/yarn
  EOS
  end

  def core_site_xml; <<-EOS.undent
  <?xml version="1.0" encoding="UTF-8"?>
  <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
  <configuration>
    <property>
      <name>hadoop.tmp.dir</name>
      <value>#{var}/hadoop/tmp</value>
    </property>

    <!-- Only accept local connections -->
    <property>
      <name>fs.defaultFS</name>
      <value>hdfs://127.0.0.1</value>
    </property>
  </configuration>
  EOS
  end

  def hdfs_site_xml; <<-EOS.undent
  <?xml version="1.0" encoding="UTF-8"?>
  <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
  <configuration>
    <property>
      <name>dfs.namenode.name.dir</name>
      <value>file:///#{var}/hadoop/hdfs/name/</value>
    </property>

    <property>
      <name>dfs.datanode.data.dir</name>
      <value>file:///#{var}/hadoop/hdfs/data/</value>
    </property>

    <property>
      <name>dfs.permissions</name>
      <value>true</value>
    </property>

    <property>
      <name>dfs.cluster.administrators</name>
      <value>#{ENV['USER']}</value>
    </property>

    <property>
      <name>dfs.permissions.supergroup</name>
      <value>staff</value>
    </property>
  </configuration>
  EOS
  end

  def yarn_site_xml; <<-EOS.undent
  <?xml version="1.0" encoding="UTF-8"?>
  <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
  <configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>

    <property>
        <name>yarn.nodemanager.aux-services.mapreduce_shuffle.class</name>
        <value>org.apache.hadoop.mapred.ShuffleHandler</value>
    </property>

    <property>
      <name>yarn.resourcemanager.hostname</name>
      <value>127.0.0.1</value>
    </property>

    <property>
      <name>yarn.log.server.url</name>
      <value>127.0.0.1:19888/jobhistory/logs</value>
    </property>

    <property>
      <name>yarn.resourcemanager.scheduler.class</name>
      <value>org.apache.hadoop.yarn.server.resourcemanager.scheduler.capacity.CapacityScheduler</value>
    </property>

    <property>
      <name>yarn.nodemanager.local-dirs</name>
      <value>#{var}/hadoop/yarn/nm-local-dir</value>
    </property>
  </configuration>
  EOS
  end

  def mapred_site_xml; <<-EOS.undent
  <?xml version="1.0" encoding="UTF-8"?>
  <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
  <configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>

    <property>
        <name>mapreduce.cluster.local.dir</name>
        <value>#{var}/hadoop/mapred</value>
    </property>
  </configuration>
  EOS
  end

  def hadoop_server; <<-EOS.undent
  #!/usr/bin/env ruby
  usage = "Usage: hadoop_server (start|stop|restart)"
  $run = true
  Signal.trap("TERM") do
    daemon "stop"
    $run = false
  end
  def daemon(action)
    system "#{libexec}/sbin/hadoop-daemon.sh", action, "namenode"
    system "#{libexec}/sbin/hadoop-daemon.sh", action, "datanode"
    system "#{libexec}/sbin/yarn-daemon.sh", action, "resourcemanager"
    system "#{libexec}/sbin/yarn-daemon.sh", action, "nodemanager"
    system "#{libexec}/sbin/mr-jobhistory-daemon.sh", action, "historyserver"
  end
  def wait_for_term()
    while $run
      sleep 10
    end
  end
  if ARGV.length == 1
    case ARGV[0]
      when "start"
        daemon "start"
      when "stop"
        daemon "stop"
      when "restart"
        daemon "stop"
        daemon "start"
      when "daemon"
        daemon "start"
        wait_for_term
      else
        puts usage
    end
  else
    puts usage
  end
  EOS
  end

  plist_options :manual => 'hadoop_server start'

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
        <string>org.apache.hadoop</string>
      <key>KeepAlive</key>
      <true/>
      <key>RunAtLoad</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/hadoop_server</string>
        <string>daemon</string>
      </array>
      <key>StandardErrorPath</key>
        <string>#{var}/log/hadoop/output.log</string>
      <key>StandardOutPath</key>
        <string>#{var}/log/hadoop/output.log</string>
    </dict>
    </plist>
  EOS
  end

  test do
    begin
      system "#{bin}/hadoop_server", "start"
      puts "Waiting 60 seconds for Hadoop to start..."
      sleep(1.minutes)
      puts "Hadoop started."
      test_text='Hello Homebrew. This is hadoop installed by Homebrew.'
      result="Hello\t1\nHomebrew.\t2\nThis\t1\nby\t1\nhadoop\t1\ninstalled\t1\nis\t1"
      hello = (testpath/'hello')
      hello.write(test_text)
      puts "Testing HDFS..."
      system "#{bin}/hdfs", 'dfs', '-copyFromLocal', 'hello', '/'
      assert $?.success?
      output_1 = `#{bin}/hdfs dfs -cat /hello`
      assert $?.success?
      assert_match test_text, output_1
      puts "Done.\nTesting mapreduce..."
      system "#{bin}/yarn",
             "jar",
             Dir["/usr/local/Cellar/hadoop/2.4.1/libexec/share/hadoop/mapreduce/*examples*.jar"].at(0),
             "wordcount",
             "/hello",
             "/out"
      assert $?.success?
      output_2 = `#{bin}/hdfs dfs -cat /out/part-r-00000`
      assert_match result, output_2
      puts 'done.\nStopping Hadoop...'
      system "#{bin}/hdfs", "dfs", "-rm", "-r", "-f", "/hello", "/out"
      system "#{bin}/hadoop_server", "stop"
      puts 'done.'
    rescue
      system "#{bin}/hdfs", "dfs", "-rm", "-r", "-f", "/hello", "/out"
      system "#{bin}/hadoop_server", "stop"
    end
  end
end
