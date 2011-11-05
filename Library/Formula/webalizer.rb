require 'formula'

class Webalizer < Formula
  url 'ftp://ftp.mrunix.net/pub/webalizer/webalizer-2.23-04-src.tgz'
  homepage 'http://www.mrunix.net/webalizer/'
  md5 'aa6e8971ecbf4407d8ea3ee9a1d9cdb3'
  version '2.23-04'

  depends_on 'gd'
  depends_on 'berkeley-db' # Enables reverse DNS support

  def install
    ENV.x11 # For libpng
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
