require 'formula'

class Remind <Formula
  url 'http://www.roaringpenguin.com/files/download/remind-03.01.09.tar.gz'
  homepage 'http://www.roaringpenguin.com/products/remind'
  md5 '261a5fb774a1d671cc71e36fd0ea02b3'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
