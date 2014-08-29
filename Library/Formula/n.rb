require "formula"

class N < Formula
  homepage "https://github.com/visionmedia/n"
  head "https://github.com/visionmedia/n.git"
  url "https://github.com/visionmedia/n/archive/v1.2.7.tar.gz"
  sha1 "1852167d79d42b5077f23197133ec717ca1b78a0"

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end
end
