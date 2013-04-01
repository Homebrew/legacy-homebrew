require 'formula'

class Srecord < Formula
  homepage 'http://srecord.sourceforge.net/'
  url 'http://srecord.sourceforge.net/srecord-1.61.tar.gz'
  sha1 '7d705a1ff389bbfd1279b4f49c80909678cc7847'

  depends_on :libtool
  depends_on 'boost'
  depends_on 'libgcrypt'
  depends_on 'ghostscript'

  def install
    system "./configure", "--prefix=#{prefix}", "LIBTOOL=glibtool"
    system "make install"
  end
end
