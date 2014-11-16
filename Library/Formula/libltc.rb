require "formula"

class Libltc < Formula
  homepage "http://x42.github.io/libltc/"
  url "https://github.com/x42/libltc/releases/download/v1.1.4/libltc-1.1.4.tar.gz"
  sha1 "b8ff317dc15807aaa7142366b4d13c0c9aa26959"

  bottle do
    cellar :any
    revision 1
    sha1 "7c4a5165544c7219c9ed12bc39bc1cf384c995bb" => :yosemite
    sha1 "c55d95885439c8d8696679742ea189db8beaca32" => :mavericks
    sha1 "75242d6344965aab837d2e66569a8f128d084ff7" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
