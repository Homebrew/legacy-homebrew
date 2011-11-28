require 'formula'

class Groonga < Formula
  url 'http://packages.groonga.org/source/groonga/groonga-1.2.8.tar.gz'
  homepage 'http://groonga.org/'
  md5 'a319b1f3a55cbf250ef5255f5c51ff46'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-zlib"
    system "make install"
  end
end
