require "formula"


class Vassh < Formula
  homepage "https://github.com/x-team/vassh"
  url "https://github.com/x-team/vassh/archive/master.tar.gz"
  sha1 "59c3b066858dacca3cc6253fea9d62c74c35ec0b"
  version "0.1"
  def install
    bin.install "./vassh.sh"
    bin.install "./vasshin"
    bin.install "./vassh"
  end
  test do
    system "which vassh"
  end
end
