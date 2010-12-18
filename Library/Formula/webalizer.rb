require 'formula'

class Webalizer <Formula
  url 'ftp://ftp.mrunix.net/pub/webalizer/webalizer-2.23-03-src.tar.bz2'
  homepage 'http://www.mrunix.net/webalizer/'
  md5 '7c67943867a33b7a56b7332af47d2b2a'
  version '2.23-03'

  depends_on 'libpng'
  depends_on 'gd'
  depends_on 'berkeley-db' # Enables reverse DNS support

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
