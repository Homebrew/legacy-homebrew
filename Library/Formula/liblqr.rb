require 'formula'

class Liblqr < Formula
  url 'http://liblqr.wikidot.com/local--files/en:download-page/liblqr-1-0.4.1.tar.bz2'
  homepage 'http://liblqr.wikidot.com/'
  sha1 '42b30b157b0c47690baa847847e24c7c94412b75'
  version '0.4.1'

  head 'git://repo.or.cz/liblqr.git'

  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
