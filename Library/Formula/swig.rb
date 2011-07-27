require 'formula'

class Swig < Formula
  url 'http://prdownloads.sourceforge.net/swig/swig-2.0.4.tar.gz'
  homepage 'http://www.swig.org/'
  md5 '4319c503ee3a13d2a53be9d828c3adc0'

  def install
    system "./configure", "--prefix=#{prefix}", "--without-pcre"
    system "make"
    system "make install"
  end
end
