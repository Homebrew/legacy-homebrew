require 'formula'

class Groonga < Formula
  url 'http://packages.groonga.org/source/groonga/groonga-1.2.6.tar.gz'
  homepage 'http://groonga.org/'
  md5 '21bc2f043304837717d3aacdf4118c7a'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-zlib"
    system "make install"
  end
end
