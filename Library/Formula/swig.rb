require 'formula'

class Swig < Formula
  homepage 'http://www.swig.org/'
  url 'http://downloads.sourceforge.net/project/swig/swig/swig-2.0.6/swig-2.0.6.tar.gz'
  md5 '86bc02218774ca75bdf7766db74a62c6'

  depends_on 'pcre'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
