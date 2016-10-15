require "formula"

class Cv < Formula
  homepage "https://github.com/BestPig/cv"
  url "https://github.com/BestPig/cv/archive/v0.4.1.tar.gz"
  sha256 "6be064bc42d59e25927b10a82c467892f405d21132f6b9d71125961769e25a2c"
  head "https://github.com/BestPig/cv.git"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/cv", "--version"
  end
end
