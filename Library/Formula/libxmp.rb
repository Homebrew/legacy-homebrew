require 'formula'

class Libxmp < Formula
  homepage 'http://xmp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/xmp/libxmp/4.1.3/libxmp-4.1.3.tar.gz'
  sha1 '1d8a2629e05abc45bf19f7f488a6c0368aa38bd7'
  head 'git://git.code.sf.net/p/xmp/libxmp'

  depends_on :autoconf if build.head?

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
