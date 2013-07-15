require 'formula'

class Bogofilter < Formula
  homepage 'http://bogofilter.sourceforge.net'
  url 'http://sourceforge.net/projects/bogofilter/files/bogofilter-1.2.3/bogofilter-1.2.3.tar.bz2'
  sha1 '1597e52140c9b3894d5d7ced11a67dcaf2444b58'

  depends_on 'berkeley-db'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
