require "formula"

class Cv < Formula
  homepage "https://github.com/BestPig/cv"
  url "https://github.com/BestPig/cv/archive/v0.5.1.tar.gz"
  sha1 "8562e4fa4ce47b25567ea027c53d0c01b0bd396d"

  def install
    system "make"
    system "make", "install"
  end
end
