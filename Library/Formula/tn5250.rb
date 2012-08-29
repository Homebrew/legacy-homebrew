require 'formula'

class Tn5250 < Formula
  homepage 'http://tn5250.sourceforge.net/'
  url 'http://sourceforge.net/projects/tn5250/files/tn5250/0.17.4/tn5250-0.17.4.tar.gz'
  md5 'd1eb7c5a2e15cd2f43a1c115e2734153'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
    system "make clean"
  end
end
