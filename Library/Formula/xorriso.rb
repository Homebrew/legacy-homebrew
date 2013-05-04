require 'formula'

class Xorriso < Formula
  homepage 'http://www.gnu.org/software/xorriso/'
  url 'http://ftpmirror.gnu.org/xorriso/xorriso-1.2.8.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/xorriso/xorriso-1.2.8.tar.gz'
  sha1 '1459ab0f8644853b9ce2197320ed4083d3d03123'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/xorriso", "--help"
  end
end
