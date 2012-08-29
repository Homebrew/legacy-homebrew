require 'formula'

class Webalizer < Formula
  homepage 'http://www.mrunix.net/webalizer/'
  url 'ftp://ftp.mrunix.net/pub/webalizer/webalizer-2.23-05-src.tgz'
  version '2.23-05'
  md5 '304338cf3b1e9389123380d5f7d88d58'

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
