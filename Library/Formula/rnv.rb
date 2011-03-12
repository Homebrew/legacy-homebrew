require 'formula'

class Rnv < Formula
  url 'http://downloads.sourceforge.net/project/rnv/Sources/1.7.10/rnv-1.7.10.tar.bz2'
  homepage 'http://freshmeat.net/projects/rnv'
  md5 '45610213e73b3e2a83ba80710e3a992c'

  depends_on 'expat'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
