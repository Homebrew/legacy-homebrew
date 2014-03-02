require 'formula'

class Libxmp < Formula
  homepage 'http://xmp.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/xmp/libxmp/4.2.5/libxmp-4.2.5.tar.gz'
  sha1 '8c60ddf76366bdbd87f845a840c204a9ade2aaf3'

  head do
    url 'git://git.code.sf.net/p/xmp/libxmp'
    depends_on :autoconf
  end

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
