require "formula"

class Ninja < Formula
  homepage "https://martine.github.io/ninja/"
  url "https://github.com/martine/ninja/archive/v1.5.3.tar.gz"
  sha1 "b3ff794461ff5e4e1e73fe6bd11e653bbe509e63"
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
