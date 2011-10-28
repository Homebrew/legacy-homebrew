require 'formula'

class Libtrace < Formula
  url 'http://research.wand.net.nz/software/libtrace/libtrace-3.0.12.tar.bz2'
  homepage 'http://research.wand.net.nz/software/libtrace.php'
  md5 '12a49bb075bfca63ee49b5025b04de21'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
