require 'formula'

class Groonga < Formula
  url 'http://packages.groonga.org/source/groonga/groonga-2.0.0.tar.gz'
  homepage 'http://groonga.org/'
  md5 '09e6a34db15cf42b6a3aff07e0f841ff'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-zlib"
    system "make install"
  end
end
