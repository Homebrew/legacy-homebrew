require 'formula'

class Libtrace < Formula
  url 'http://research.wand.net.nz/software/libtrace/libtrace-3.0.9.tar.bz2'
  homepage 'http://research.wand.net.nz/software/libtrace.php'
  md5 'c793a134e6a8cf4f0961128039bbd268'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
