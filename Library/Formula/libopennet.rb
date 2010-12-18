require 'formula'

class Libopennet <Formula
  url 'http://www.rkeene.org/files/oss/libopennet/libopennet-0.9.9.tar.gz'
  homepage 'http://www.rkeene.org/oss/libopennet'
  md5 '621294efc0d2d1a839d6262359b46f9c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
