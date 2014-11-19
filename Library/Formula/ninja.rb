require "formula"

class Ninja < Formula
  homepage "https://martine.github.io/ninja/"
  url "https://github.com/martine/ninja/archive/v1.5.1.tar.gz"
  sha1 "c5a3af39f6d7ee3a30263f34091c046964d442f0"
  head "https://github.com/martine/ninja.git"

  option "without-tests", "Run build-time tests"

  resource "gtest" do
    url "https://googletest.googlecode.com/files/gtest-1.7.0.zip"
    sha1 "f85f6d2481e2c6c4a18539e391aa4ea8ab0394af"
  end

  def install
    system "python", "bootstrap.py"

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
