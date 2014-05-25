require "formula"

class Wgetpaste < Formula
  homepage "http://wgetpaste.zlin.dk/"
  url "http://wgetpaste.zlin.dk/wgetpaste-2.25.tar.bz2"
  sha1 "4f2220714522c724928dee67ed1c5d7feed1c207"

  def install
    bin.install "wgetpaste"
  end
end
