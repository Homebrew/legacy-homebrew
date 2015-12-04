class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://martine.github.io/ninja/"
  url "https://github.com/martine/ninja/archive/v1.6.0.tar.gz"
  sha256 "b43e88fb068fe4d92a3dfd9eb4d19755dae5c33415db2e9b7b61b4659009cde7"
  head "https://github.com/martine/ninja.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "facfca510094c956257dbffd94719139eb7a8f7ad8362d4064638c753268b6fe" => :el_capitan
    sha256 "827e1ce721bd8c95fea9093b74fa5c9d9b5aa0e2660241b44b5f5233833c58f0" => :yosemite
    sha256 "7a8da38c247855e12054ea7dc8ca8796be19151a2683fcaf50772780d122e90a" => :mavericks
    sha256 "3717352656bb260ac96de4a0db856ebaa6602c6b4f4d42a0d2475ba511ab834f" => :mountain_lion
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
