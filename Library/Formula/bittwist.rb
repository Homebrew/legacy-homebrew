require "formula"

class Bittwist < Formula
  homepage "http://bittwist.sourceforge.net"
  url "https://downloads.sourceforge.net/project/bittwist/Mac%20OS%20X/Bit-Twist%202.0/bittwist-macosx-2.0.tar.gz"
  sha1 "fcc652f838858edbf86546af945a71b815cf4d6b"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/bittwist -help"
    system "#{bin}/bittwiste -help"
  end
end
