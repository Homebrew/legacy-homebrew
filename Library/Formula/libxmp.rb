require 'formula'

class Libxmp < Formula
  homepage 'http://xmp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/xmp/libxmp/4.1.1/libxmp-4.1.1.tar.gz'
  sha1 '42896b910f496a974caae95f543e7a12b6ec35fe'
  head 'git://git.code.sf.net/p/xmp/libxmp'

  depends_on :autoconf if build.head?

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
