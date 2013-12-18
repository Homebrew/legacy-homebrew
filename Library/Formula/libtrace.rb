require 'formula'

class Libtrace < Formula
  homepage 'http://research.wand.net.nz/software/libtrace.php'
  url 'http://research.wand.net.nz/software/libtrace/libtrace-3.0.18.tar.bz2'
  sha1 '91003fefe014d92cccc3e6c0b3d82b21a9bfdf48'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
