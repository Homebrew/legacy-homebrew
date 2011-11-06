require 'formula'

class A52dec < Formula
  url 'http://liba52.sourceforge.net/files/a52dec-0.7.4.tar.gz'
  homepage 'http://liba52.sourceforge.net/'
  md5 'caa9f5bc44232dc8aeea773fea56be80'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared",
                          "--mandir=#{man}"
    system "make install"
  end
end
