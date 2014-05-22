require "formula"

class Rgbds < Formula
  homepage "http://anthony.bentley.name/rgbds/"
  url "https://github.com/pbjchang/rgbds/archive/v0.0.3.zip"
  sha1 "d7c497465911c80c96eba05149499f7193a927cd"

  head "https://github.com/bentley/rgbds.git"

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
