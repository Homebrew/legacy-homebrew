require 'formula'

class Groonga < Formula
  url 'http://packages.groonga.org/source/groonga/groonga-1.2.9.tar.gz'
  homepage 'http://groonga.org/'
  md5 '47117baa401a3db08362e00f94fced12'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-zlib"
    system "make install"
  end
end
