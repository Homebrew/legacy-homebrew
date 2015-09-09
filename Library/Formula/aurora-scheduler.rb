# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/homebrew/master/frames
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class AuroraScheduler < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org/"
  url "http://www.us.apache.org/dist/aurora/0.9.0/apache-aurora-0.9.0.tar.gz"
  version "0.9.0"
  sha256 "16040866f3a799226452b1541892eb80ed3c61f47c33f1ccb0687fb5cf82767c"

  depends_on "python" => :build
  depends_on "gradle" => :build

  def install
	system "sed \"s/<=/</g\" buildSrc/build.gradle \> buildSrc/build.gradle"
    system "gradle", "wrapper"
    system "./gradlew", "distZip"
    system "./pants", "binary", "src/main/python/apache/aurora/admin:kaurora_admin"
    system "./pants", "binary", "src/main/python/apache/aurora/client/cli:kaurora"
    #system "./pants", "binary", "src/main/python/apache/aurora/executor/bin:thermos_executor"
    #system "./pants", "binary", "src/main/python/apache/thermos/bin:thermos_runner"
    system "./pants", "binary", "src/main/python/apache/aurora/tools:thermos_observer"
    bin.install "dist/kaurora.pex"
    bin.install "dist/kaurora_admin.pex"
	prefix.install Dir["dist/install/aurora-scheduler/*"]
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test apache-aurora`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    #system "false"
  end
end
