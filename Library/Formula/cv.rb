require "formula"

class Cv < Formula
  homepage "https://github.com/BestPig/cv"
  url "https://github.com/BestPig/cv/archive/v0.4.1.tar.gz"
  sha1 "4621dd0eb2bea2bdbbfa50904fb555a90ff3e446"

  def install
    system "make"
    system "make", "install"
  end
end
