require 'formula'

class Libtrace < Formula
  homepage 'http://research.wand.net.nz/software/libtrace.php'
  url 'http://research.wand.net.nz/software/libtrace/libtrace-3.0.14.tar.bz2'
  sha1 '9e860ebd280a9c927b254e1936b87888c844b458'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
