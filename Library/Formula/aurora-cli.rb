class AuroraCli < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=aurora/0.10.0/apache-aurora-0.10.0.tar.gz"
  sha256 "de2ce397ded50c0327c0e5f8599fc7e9b0e1fd0683271023e885e6827972c62c"

  bottle do
    cellar :any_skip_relocation
    sha256 "55cdd3e6ba2f0d2ceb9eafc8bab0ec2c754c5f8a789d5db3b9284f8615465e4c" => :el_capitan
    sha256 "928d8922021aa8e080d00025ed9d40904815d94a3313094ad1844a2c74d03578" => :yosemite
    sha256 "f92482b9042058b5dc7b70cb34235c96c84eb53dcad264dc02d0549f7328f99d" => :mavericks
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
