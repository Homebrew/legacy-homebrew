require 'formula'

class Lzo <Formula
  url 'http://www.oberhumer.com/opensource/lzo/download/lzo-2.03.tar.gz'
  homepage 'http://www.oberhumer.com/opensource/lzo/'
  md5 '0c3d078c2e8ea5a88971089a2f02a726'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--enable-shared=yes"
    system "make install"
  end
end
