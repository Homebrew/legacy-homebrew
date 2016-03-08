class AuroraCli < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=/aurora/0.12.0/apache-aurora-0.12.0.tar.gz"
  sha256 "682e953237811d4fb0c94a08fd027c967de637be4260a32c19ee1e77c0f930e9"

  bottle do
    cellar :any_skip_relocation
    sha256 "972ec962a20a2ff5965021f9debd1250a218872930f329fe02ce24b89f3ddabf" => :el_capitan
    sha256 "d9f55f00969a914f59c19774431fe6001428bb51e3c5340912091cd3a3a89b38" => :yosemite
    sha256 "7b50d4dd3e5a6cf77aee79f41d63c0a4c33fe9cd2c31bb4f5f5892f1bb118b1d" => :mavericks
  end

  depends_on :java => "1.8+"
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    system "./pants", "binary", "src/main/python/apache/aurora/kerberos:kaurora"
    system "./pants", "binary", "src/main/python/apache/aurora/kerberos:kaurora_admin"
    bin.install "dist/kaurora.pex" => "aurora"
    bin.install "dist/kaurora_admin.pex" => "aurora_admin"
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
