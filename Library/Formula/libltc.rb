class Libltc < Formula
  desc "POSIX-C Library for handling Linear/Logitudinal Time Code (LTC)"
  homepage "https://x42.github.io/libltc/"
  url "https://github.com/x42/libltc/releases/download/v1.1.4/libltc-1.1.4.tar.gz"
  sha256 "7d9c43601190b2702de03080cf9cd1c314c523b09d19aa4ac0d08610d7075a75"

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
