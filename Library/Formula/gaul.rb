require 'formula'

class Gaul < Formula
  homepage 'http://gaul.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/gaul/gaul-devel/0.1850-0/gaul-devel-0.1850-0.tar.gz'
  sha1 '2ec57a5bce2ff7fc9f9c3453b2ea2d3aec248350'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--disable-g",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
