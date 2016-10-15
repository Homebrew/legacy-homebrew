require "formula"

class Rgbds < Formula
  homepage "http://anthony.bentley.name/rgbds/"
  url "https://github.com/pbjchang/rgbds/archive/v0.0.3.tar.gz"
  sha1 "856b2d1532e5561d8a17c703f1610eb99e53f005"

  head "https://github.com/pbjchang/rgbds.git"

  def install
    ENV.deparallelize  # asmy.h needs to be built first
    (buildpath/"bin").mkpath
    (buildpath/"man/man1").mkpath
    (buildpath/"man/man7").mkpath
    system "make", "install", "PREFIX=#{buildpath}"
    prefix.install "bin"
    man.install "man/man1"
    man.install "man/man7"
  end
end
