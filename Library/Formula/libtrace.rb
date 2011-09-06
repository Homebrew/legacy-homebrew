require 'formula'

class Libtrace < Formula
  url 'http://research.wand.net.nz/software/libtrace/libtrace-3.0.11.tar.bz2'
  homepage 'http://research.wand.net.nz/software/libtrace.php'
  md5 '63ae389c4e87d4fa818697db18a5ba82'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
