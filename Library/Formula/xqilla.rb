require 'formula'

class Xqilla < Formula
  homepage 'http://xqilla.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/xqilla/xqilla/2.3.0/XQilla-2.3.0.tar.gz'
  sha1 'facfd0134652cef7ebbc3c54d61fc248c1610c95'

  depends_on 'xerces-c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
