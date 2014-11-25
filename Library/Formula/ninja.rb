require "formula"

class Ninja < Formula
  homepage "https://martine.github.io/ninja/"
  url "https://github.com/martine/ninja/archive/v1.5.3.tar.gz"
  sha1 "b3ff794461ff5e4e1e73fe6bd11e653bbe509e63"
  head "https://github.com/martine/ninja.git"

  bottle do
    cellar :any
    sha1 "f5c298094cdfd6453eadd99703facba3d16b4afc" => :yosemite
    sha1 "fe6f6a2b861a7228b381d83582a8f5e95fd9a2a8" => :mavericks
    sha1 "141091bfdeb40caf0538413f01c72ce5c89a3e76" => :mountain_lion
  end

  option "without-tests", "Run build-time tests"

  resource "gtest" do
    url "https://googletest.googlecode.com/files/gtest-1.7.0.zip"
    sha1 "f85f6d2481e2c6c4a18539e391aa4ea8ab0394af"
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
end
