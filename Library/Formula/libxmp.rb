require 'formula'

class Libxmp < Formula
  homepage 'http://xmp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/xmp/libxmp/4.1.5/libxmp-4.1.5.tar.gz'
  sha1 'f50ff6d98e9c21c8fb5e29a8c9e5677983285d90'
  head 'git://git.code.sf.net/p/xmp/libxmp'

  depends_on :autoconf if build.head?

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
