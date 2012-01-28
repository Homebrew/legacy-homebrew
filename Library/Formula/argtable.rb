require 'formula'

class Argtable < Formula
  url 'http://sourceforge.net/projects/argtable/files/argtable/argtable-2.13/argtable2-13.tar.gz'
  homepage 'http://argtable.sourceforge.net/'
  md5 '156773989d0d6406cea36526d3926668'
  version '2.13'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
