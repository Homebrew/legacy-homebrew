require 'formula'

class Groonga < Formula
  url 'http://packages.groonga.org/source/groonga/groonga-1.2.4.tar.gz'
  homepage 'http://groonga.org/'
  md5 '58faebee3055f849e01be953eb4a6b7f'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-zlib"
    system "make install"
  end
end
