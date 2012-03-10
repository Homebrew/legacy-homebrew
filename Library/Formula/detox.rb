require 'formula'

class Detox < Formula
  url 'http://downloads.sourceforge.net/project/detox/detox/1.2.0/detox-1.2.0.tar.bz2'
  homepage 'http://detox.sourceforge.net/'
  md5 'da34c6bc3c68ce2fb008e25066e72927'

  def install
    system "./configure", "--mandir=#{man}", "--prefix=#{prefix}"
    system "make"
    (prefix + "etc").mkpath
    (share + "detox").mkpath
    system "make install"
  end
end
