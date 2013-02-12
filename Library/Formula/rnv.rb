require 'formula'

class Rnv < Formula
  homepage 'http://freshmeat.net/projects/rnv'
  url 'http://downloads.sourceforge.net/project/rnv/Sources/1.7.10/rnv-1.7.10.tar.bz2'
  sha1 'f85fa4b8da41758e51f8192b1c0974f62c53a242'

  depends_on 'expat'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
