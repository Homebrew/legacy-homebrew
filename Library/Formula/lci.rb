require 'formula'

class Lci < Formula
  homepage 'http://lci.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/lci/lci/0.6/lci-0.6.tar.gz'
  sha1 '0b03f4c2d47a3e217f760e371ec60bed8b477b02'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
