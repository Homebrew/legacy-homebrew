require 'formula'

class Srecord < Formula
  homepage 'http://srecord.sourceforge.net/'
  url 'http://srecord.sourceforge.net/srecord-1.60.tar.gz'
  sha1 '0e0e94e735578346138c916117a8d6c8324e9fec'

  depends_on 'boost'
  depends_on 'libgcrypt'

  def install
    system "./configure", "--prefix=#{prefix}", "LIBTOOL=glibtool"
    system "make install"
  end
end
