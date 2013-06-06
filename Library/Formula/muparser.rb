require 'formula'

class Muparser < Formula
  homepage 'http://muparser.sourceforge.net/'
  url 'http://sourceforge.net/projects/muparser/files/muparser/Version%201.34/muparser_v134.tar.gz'
  sha1 'd6d834d3ba2bd3c316c9b3070369d32701703f78'
  version '1.34'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
