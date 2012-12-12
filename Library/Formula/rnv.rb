require 'formula'

class Rnv < Formula
  url 'http://downloads.sourceforge.net/project/rnv/Sources/1.7.10/rnv-1.7.10.tar.bz2'
  homepage 'http://freshmeat.net/projects/rnv'
  sha1 'f85fa4b8da41758e51f8192b1c0974f62c53a242'

  depends_on 'expat'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
