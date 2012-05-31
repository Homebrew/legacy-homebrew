require 'formula'

class Xqilla < Formula
  url 'http://downloads.sourceforge.net/project/xqilla/xqilla/2.2.4/XQilla-2.2.4.tar.gz'
  homepage 'http://xqilla.sourceforge.net/'
  md5 'a00672133d06772f54f18d0fda304c02'

  depends_on 'xerces-c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
