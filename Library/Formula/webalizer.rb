require 'formula'

class Webalizer <Formula
  url 'ftp://ftp.mrunix.net/pub/webalizer/webalizer-2.21-02-src.tar.bz2'
  homepage 'http://www.mrunix.net/webalizer/'
  md5 '29af2558a5564493df654b6310b152e7'
  version '2.21-02'

  depends_on 'libpng'
  depends_on 'gd'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
