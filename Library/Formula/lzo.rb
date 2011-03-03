require 'formula'

class Lzo <Formula
  url 'http://www.oberhumer.com/opensource/lzo/download/lzo-2.04.tar.gz'
  homepage 'http://www.oberhumer.com/opensource/lzo/'
  md5 'a383c7055a310e2a71b9ecd19cfea238'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--enable-shared=yes"
    system "make install"
  end
end
