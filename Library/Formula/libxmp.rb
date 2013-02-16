require 'formula'

class Libxmp < Formula
  homepage 'http://xmp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/xmp/libxmp/4.0.1/libxmp-4.0.1.tar.gz'
  sha1 '2deeb3df362f01dcd39a874c83010c02bf4e8177'
  head 'git://xmp.git.sourceforge.net/gitroot/xmp/xmp'

  depends_on :autoconf if build.head?

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
