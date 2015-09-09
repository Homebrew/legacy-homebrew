# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/homebrew/master/frames
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class AuroraScheduler < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "http://aurora.apache.org/"
  url "http://www.us.apache.org/dist/aurora/0.9.0/apache-aurora-0.9.0.tar.gz"
  version "0.9.0"
  sha256 "16040866f3a799226452b1541892eb80ed3c61f47c33f1ccb0687fb5cf82767c"

  depends_on "python" => :build
  depends_on "gradle" => :build

  def install
    # TODO aurora-schduler
	#system "sed \"s/<=/</g\" buildSrc/build.gradle \> buildSrc/build.gradle"
    #system "gradle", "wrapper"
    #system "./gradlew", "installDist"

    # aurora client
    system "./pants", "binary", "src/main/python/apache/aurora/admin:kaurora_admin"
    system "./pants", "binary", "src/main/python/apache/aurora/client/cli:kaurora"

    # TODO thermos
    #system "./pants", "binary", "src/main/python/apache/aurora/executor/bin:thermos_executor"
    #system "./pants", "binary", "src/main/python/apache/thermos/bin:thermos_runner"
    #system "./pants", "binary", "src/main/python/apache/aurora/tools:thermos_observer"

	#prefix.install Dir["dist/install/aurora-scheduler/*"]
    system "mv", "dist/kaurora.pex", "dist/aurora"
    system "mv", "dist/kaurora_admin.pex", "dist/aurora_admin"
    bin.install "dist/aurora"
    bin.install "dist/aurora_admin"
  end
end
