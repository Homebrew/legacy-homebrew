class AuroraScheduler < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "http://aurora.apache.org/"
  url "http://www.us.apache.org/dist/aurora/0.9.0/apache-aurora-0.9.0.tar.gz"
  version "0.9.0"
  sha256 "16040866f3a799226452b1541892eb80ed3c61f47c33f1ccb0687fb5cf82767c"

  depends_on "python" => :build

  def install
    system "./pants", "binary", "src/main/python/apache/aurora/admin:kaurora_admin"
    system "./pants", "binary", "src/main/python/apache/aurora/client/cli:kaurora"
    system "mv", "dist/kaurora.pex", "dist/aurora"
    system "mv", "dist/kaurora_admin.pex", "dist/aurora_admin"
    bin.install "dist/aurora"
    bin.install "dist/aurora_admin"
  end
end
