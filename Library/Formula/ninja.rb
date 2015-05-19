class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://martine.github.io/ninja/"
  url "https://github.com/martine/ninja/archive/v1.5.3.tar.gz"
  sha256 "7c953b5a7c26cfcd082882e3f3e2cd08fee8848ad228bb47223b18ea18777ec0"
  head "https://github.com/martine/ninja.git"

  bottle do
    cellar :any
    sha1 "e82dc5e952531ce5a586275c1078e3c35a15246b" => :yosemite
    sha1 "04e4fc5a7ee416e248fd42eab9fe04a26f79fc96" => :mavericks
    sha1 "553fca852991a02ed526d4a37f79aa60c50f23ee" => :mountain_lion
  end

  option "without-tests", "Run build-time tests"

  resource "gtest" do
    url "https://googletest.googlecode.com/files/gtest-1.7.0.zip"
    sha256 "247ca18dd83f53deb1328be17e4b1be31514cedfc1e3424f672bf11fd7e0d60d"
  end

  def install
    system "python", "configure.py", "--bootstrap"

    if build.with? "tests"
      (buildpath/"gtest").install resource("gtest")
      system buildpath/"configure.py", "--with-gtest=gtest"
      system buildpath/"ninja", "ninja_test"
      system buildpath/"ninja_test", "--gtest_filter=-SubprocessTest.SetWithLots"
    end

    bin.install "ninja"
    bash_completion.install "misc/bash-completion" => "ninja-completion.sh"
    zsh_completion.install "misc/zsh-completion" => "_ninja"
  end

  test do
    (testpath/"build.ninja").write <<-EOS.undent
      cflags = -Wall

      rule cc
        command = gcc $cflags -c $in -o $out

      build foo.o: cc foo.c
    EOS
    system bin/"ninja", "-t", "targets"
  end
end
