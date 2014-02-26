require "formula"

class Vassh < Formula
  homepage "https://github.com/x-team/vassh"
  url "https://github.com/x-team/vassh/archive/0.1.tar.gz"
  sha1 "74e6954e030e0e578390dd16d98a5c7dcaf09208"

  def install
    bin.install "./vassh.sh"
    bin.install "./vasshin"
    bin.install "./vassh"
  end

  test do
    system "which vassh"
  end
end
