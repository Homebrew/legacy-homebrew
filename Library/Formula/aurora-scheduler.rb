class AuroraScheduler < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=aurora/0.9.0/apache-aurora-0.9.0.tar.gz"
  sha256 "16040866f3a799226452b1541892eb80ed3c61f47c33f1ccb0687fb5cf82767c"

  depends_on :java => "1.8+"
  depends_on "gradle" => :build

  def install
    system "sed \"s/<=/</g\" buildSrc/build.gradle \> buildSrc/build.gradle"
    system "gradle", "installDist"

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["CFLAGS"] = "-Qunused-arguments"
    ENV["CPPFLAGS"] = "-Qunused-arguments"

    system "./pants", "binary", "src/main/python/apache/aurora/client/cli:kaurora"
    system "./pants", "binary", "src/main/python/apache/aurora/admin:kaurora_admin"

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
    system "aurora", "--version"
    system "aurora", "--help"
    system "aurora_admin", "--help"
  end
end
