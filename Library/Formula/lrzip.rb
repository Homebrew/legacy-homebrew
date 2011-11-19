require 'formula'

class Lrzip < Formula
  url 'http://ck.kolivas.org/apps/lrzip/lrzip-0.604.tar.bz2'
  homepage 'http://lrzip.kolivas.org'
  md5 '9a405bf7fa04479abb24c4e3074ea843'

  depends_on 'pkg-config' => :build
  depends_on "lzo"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
