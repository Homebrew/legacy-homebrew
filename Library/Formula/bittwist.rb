class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "http://bittwist.sourceforge.net"
  url "https://downloads.sourceforge.net/project/bittwist/Mac%20OS%20X/Bit-Twist%202.0/bittwist-macosx-2.0.tar.gz"
  sha256 "8954462ac9e21376d9d24538018d1225ef19ddcddf9d27e0e37fe7597e408eaa"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/bittwist -help"
    system "#{bin}/bittwiste -help"
  end
end
