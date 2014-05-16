require "formula"

class Libltc < Formula
  homepage "http://x42.github.io/libltc/"
  url "https://github.com/x42/libltc/releases/download/v1.1.4/libltc-1.1.4.tar.gz"
  sha1 "b8ff317dc15807aaa7142366b4d13c0c9aa26959"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
