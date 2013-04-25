require 'formula'

class Libxmp < Formula
  homepage 'http://xmp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/xmp/libxmp/4.0.4/libxmp-4.0.4.tar.gz'
  sha1 'b8078f9565eba4ad540b7ac3dc4c98e6369bd760'
  head 'git://git.code.sf.net/p/xmp/libxmp'

  depends_on :autoconf if build.head?

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
