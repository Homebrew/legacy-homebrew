
class GitPatchDownloadStrategy < GitDownloadStrategy
  def initialize(name, resource)
    super
    @baseref = meta[:base]
  end

  def stage
    Homebrew.system("git", "-C", cached_location, "diff", @baseref, @ref) do
      $stdout.reopen("patch")
    end
  end
end

class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://martine.github.io/ninja/"
  head "https://github.com/martine/ninja.git"
  stable do
    url "https://github.com/martine/ninja/archive/v1.6.0.tar.gz"
    sha256 "b43e88fb068fe4d92a3dfd9eb4d19755dae5c33415db2e9b7b61b4659009cde7"
    patch :p1 do
      # cherry-pick from HEAD
      #   d3441a0 Search for generated headers relative to build dir.
      #   1beea93 Allow configure script to bootstrap out of source.
      url "https://github.com/martine/ninja.git",
          :using    => GitPatchDownloadStrategy,
          :revision => "d3441a03386e0d1766c1a4b79d5fa5098786860f",
          :base     => "a05d4644d13624e716093fc4bd88a21e6d20223c"
    end
  end

  bottle do
    cellar :any
    sha256 "827e1ce721bd8c95fea9093b74fa5c9d9b5aa0e2660241b44b5f5233833c58f0" => :yosemite
    sha256 "7a8da38c247855e12054ea7dc8ca8796be19151a2683fcaf50772780d122e90a" => :mavericks
    sha256 "3717352656bb260ac96de4a0db856ebaa6602c6b4f4d42a0d2475ba511ab834f" => :mountain_lion
  end

  option :dsym
  option "without-tests", "Run build-time tests"

  resource "gtest" do
    url "https://googletest.googlecode.com/files/gtest-1.7.0.zip"
    sha256 "247ca18dd83f53deb1328be17e4b1be31514cedfc1e3424f672bf11fd7e0d60d"
  end

  def install
    mktemp do
      system "python", "#{buildpath}/configure.py", "--bootstrap"

      if build.with? "tests"
        (buildpath/"gtest").install resource("gtest")
        system buildpath/"configure.py", "--with-gtest=gtest"
        system "./ninja", "ninja_test"
        system "./ninja_test", "--gtest_filter=-SubprocessTest.SetWithLots"
      end

      bin.install "ninja"
      install_dsym if build.dsym?
    end

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
