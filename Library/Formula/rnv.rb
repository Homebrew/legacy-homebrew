require 'formula'

class Rnv < Formula
  homepage 'http://freshmeat.net/projects/rnv'
  url 'https://downloads.sourceforge.net/project/rnv/Sources/1.7.11/rnv-1.7.11.tar.bz2'
  sha1 '1a4475cbb6ff6da9e98cd8cceae7356e9a9f72b4'

  depends_on 'expat'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
