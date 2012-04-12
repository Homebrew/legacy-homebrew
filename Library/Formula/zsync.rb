require 'formula'

class Zsync < Formula
  homepage 'http://zsync.moria.org.uk/'
  url 'http://zsync.moria.org.uk/download/zsync-0.6.2.tar.bz2'
  md5 '862f90bafda118c4d3c5ee6477e50841'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
