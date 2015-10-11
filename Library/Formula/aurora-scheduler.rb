class AuroraScheduler < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=aurora/0.9.0/apache-aurora-0.9.0.tar.gz"
  sha256 "16040866f3a799226452b1541892eb80ed3c61f47c33f1ccb0687fb5cf82767c"

  depends_on "gradle" => :build
  depends_on "mesos"
  depends_on :java => "1.8+"

  def pour_bottle?
    quiet_system("/usr/libexec/java_home --version 1.8 --failfast")
  end

  def install
    ENV["PIP_DEFAULT_TIMEOUT"] = "60"
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["CFLAGS"] = "-Qunused-arguments"
    ENV["CPPFLAGS"] = "-Qunused-arguments"
    system "./pants", "binary", "src/main/python/apache/aurora/client/cli:kaurora"
    system "./pants", "binary", "src/main/python/apache/aurora/admin:kaurora_admin"
    system "./pants", "binary", "src/main/python/apache/aurora/tools:thermos"
    system "./pants", "binary", "src/main/python/apache/aurora/tools:thermos_observer"
    system "./pants", "binary", "src/main/python/apache/thermos/bin:thermos_runner"
    bin.install "dist/kaurora.pex" => "aurora"
    bin.install "dist/kaurora_admin.pex" => "aurora_admin"
    bin.install "dist/thermos_runner.pex" => "thermos_runner"
    bin.install "dist/thermos_observer.pex" => "thermos_observer"
  end

  test do
    ENV["AURORA_CONFIG_ROOT"] = "#{testpath}"
    (testpath/"clusters.json").write <<-EOS.undent
        [{
          "name": "devcluster",
          "slave_root": "/tmp/mesos/",
          "zk": "172.16.64.185",
          "scheduler_zk_path": "/aurora/scheduler",
          "auth_mechanism": "UNAUTHENTICATED"
        }]
    EOS
    system "#{bin}/aurora_admin", "get_cluster_config", "devcluster"
  end
end
