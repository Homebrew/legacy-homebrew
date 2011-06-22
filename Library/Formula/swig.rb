require 'formula'

class Swig < Formula
  url 'http://downloads.sourceforge.net/swig/swig-2.0.4.tar.gz'
  homepage 'http://www.swig.org/'
  md5 '4319c503ee3a13d2a53be9d828c3adc0'

  depends_on 'pcre'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking",
                          # turns prefix/share/swig/2.0.4 into prefix/share/swig
                          # as versioned dirs are redundant with Homebrew
                           "--with-swiglibdir=#{share}/swig"

    system "make"
    system "make install"
  end
end
