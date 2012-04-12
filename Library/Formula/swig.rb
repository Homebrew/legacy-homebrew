require 'formula'

class Swig < Formula
  url 'http://downloads.sourceforge.net/project/swig/swig/swig-2.0.4/swig-2.0.4.tar.gz'
  homepage 'http://www.swig.org/'
  md5 '4319c503ee3a13d2a53be9d828c3adc0'

  depends_on 'pcre'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
