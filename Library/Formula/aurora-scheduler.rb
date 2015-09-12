class AuroraScheduler < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=aurora/0.9.0/apache-aurora-0.9.0.tar.gz"
  sha256 "16040866f3a799226452b1541892eb80ed3c61f47c33f1ccb0687fb5cf82767c"

  depends_on "mesos" => :test
  depends_on "zookeeper" => :test
  depends_on :java => "1.8+"
  depends_on "gradle" => :build

  def install
    system "sed \"s/<=/</g\" buildSrc/build.gradle \> buildSrc/build.gradle"
    system "gradle", "wrapper"
    system "./gradlew", "installDist"

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["CFLAGS"] = "-Qunused-arguments"
    ENV["CPPFLAGS"] = "-Qunused-arguments"

    system "pip", "install", "mesos.interface", "--egg", "--upgrade"
    system "pip", "install", "mesos.native", "--egg", "--upgrade"

    system "./pants", "binary", "src/main/python/apache/aurora/client/cli:kaurora"
    system "./pants", "binary", "src/main/python/apache/aurora/admin:kaurora_admin"

    #system "./pants", "binary", "src/main/python/apache/aurora/executor/bin:thermos_executor"
    system "./pants", "binary", "src/main/python/apache/aurora/tools:thermos"
    system "./pants", "binary", "src/main/python/apache/aurora/tools:thermos_observer"
    system "./pants", "binary", "src/main/python/apache/thermos/bin:thermos_runner"
    system "build-support/embed_runner_in_executor.py"

    prefix.install Dir["dist/install/aurora-scheduler/*"]
    bin.install "dist/kaurora.pex" => "aurora"
    bin.install "dist/kaurora_admin.pex" => "aurora_admin"
    bin.install "dist/thermos_executor.pex" => "thermos_executor"
    bin.install "dist/thermos_runner.pex" => "thermos_runner"
    bin.install "dist/thermos_observer.pex" => "thermos_observer"
  end

  test do
    require "timeout"
    
    system "zkServer", "start"
    
    master = fork do
      exec "mesos-master", "--ip=127.0.0.1",
                                   "--registry=in_memory"
                                   "--zk=zk://127.0.0.1:2181/mssos/master"
    end
    slave = fork do
      exec "mesos-slave", "--master=127.0.0.1:5050",
                                  "--work_dir=#{testpath}"
    end
    Timeout.timeout(15) do
      system "mesos", "execute",
                             "--master=127.0.0.1:5050",
                             "--name=execute-touch",
                             "--command=touch\s#{testpath}/executed"
    end

    system "mesos-log", "initialize", "--path=#{testpath}/db"

    (testpath/"scheduler-local.sh").write <<-EOS.undent
        #!/usr/bin/env bash
        AURORA_SCHEDULER_HOME=/usr/local
        JAVA_OPTS=(
          -server
          -Xmx1g
          -Xms1g
          -Djava.library.path=/usr/local/lib
        )
        AURORA_FLAGS=(
          -cluster_name=devcluster
          -http_port=8081
          -native_log_quorum_size=1
          -zk_endpoints=127.0.0.1:2181
          -mesos_master_address=zk://127.0.0.1:2181/mesos/master
          -serverset_path=/aurora/scheduler
          -native_log_zk_group_path=/aurora/replicated-log
          -native_log_file_path="#{testpath}/db"
          -backup_dir="$AURORA_SCHEDULER_HOME/backups"
          -thermos_executor_path=/dev/null
          -vlog=INFO
          -logtostderr
        )

        export GLOG_v=0
        export LIBPROCESS_PORT=8083

        JAVA_OPTS="${JAVA_OPTS[*]}" exec "$AURORA_SCHEDULER_HOME/bin/aurora-scheduler" "${AURORA_FLAGS[@]}"
    EOS

    aurora = fork do
      system "chmod", "+x", "#{testpath}/scheduler-local.sh"
      exec "#{testpath}/scheduler-local.sh"
    end

    (testpath/"hello_world.aurora").write <<-EOS.undent
        import getpass

        run_hello_server = Process(
          name = 'run_server',
          cmdline = """
            while true; do
              echo hello world
              sleep 10
            done
          """)

        server_task = SequentialTask(
          processes = [run_hello_server],
          resources = Resources(cpu = 1.0, ram = 128*MB, disk = 64*MB)
        )

        job = Service (
          name = 'hello_world', 
          cluster = 'devcluster',
          instances = 1, 
          task = server_task,
          role = getpass.getuser(),
          environment = 'devel',
          contact = '{{role}}@localhost',
          announce=Announcer(),
        )

        jobs = [ job ]
    EOS
    assert File.exist?("#{testpath}/executed")
    
    system "python", "-c", "import mesos.native"
    system "aurora", "--version"
    system "aurora", "--help"
    #system "#{bin}/aurora", "config", "#{testpath}/hello_world.aurora"

    #system "#{bin}/aurora", "job", "create", "devcluster/www-data/test/hello_world", "#{testpath}/hello_world.aurora", "--verbose"
    #system "#{bin}/aurora", "job", "killall", "devcluster/www-data/test/hello_world"
    #Timeout.timeout(15) do
    #  system "#{bin}/aurora", "task", "run", "devcluster/www-data/test/hello_world", "hostname"
    #end
    system "zkServer", "stop"

    Process.kill("TERM", master)
    Process.kill("TERM", slave)
    Process.kill("SIGKILL", aurora)

  end
end
