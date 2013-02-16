require 'formula'

class Libxmp < Formula
  homepage 'http://xmp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/xmp/libxmp/4.0.0/libxmp-4.0.0.tar.gz'
  sha1 '2112a877b2eb91e013ff83779f6de870572ed516'
  head 'git://xmp.git.sourceforge.net/gitroot/xmp/xmp'

  depends_on :autoconf if build.head?

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
