require 'formula'

class Tn5250 < Formula
  homepage 'http://tn5250.sourceforge.net/'
  url 'http://sourceforge.net/projects/tn5250/files/tn5250/0.17.4/tn5250-0.17.4.tar.gz'
  sha1 '2c84f03f798fd5095009d6798d1e6c0b29e48a75'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
    system "make clean"
  end
end
