require 'formula'

class Freeglut < Formula
  homepage 'http://freeglut.sourceforge.net/'
  url 'http://sourceforge.net/projects/freeglut/files/freeglut/2.8.0/freeglut-2.8.0.tar.gz'
  sha1 '4debbe559c6c9841ce1abaddc9d461d17c6083b1'

  depends_on :x11

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make all"
    system "make install"
  end
end
