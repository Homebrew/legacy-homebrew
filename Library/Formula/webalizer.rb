require 'formula'

class Webalizer < Formula
  homepage 'http://www.mrunix.net/webalizer/'
  url 'ftp://ftp.mrunix.net/pub/webalizer/webalizer-2.23-05-src.tgz'
  sha1 'bc28ff28d9484c8e9793ec081c7cbfcb1f577351'

  depends_on 'gd'
  depends_on 'berkeley-db'
  depends_on :libpng

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
