require 'formula'

class Frobtads < Formula
  url 'http://www.tads.org/frobtads/frobtads-0.13.tar.gz'
  homepage 'http://www.tads.org/frobtads.htm'
  md5 'b6f25787b9ff7b89931d765046c68642'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
