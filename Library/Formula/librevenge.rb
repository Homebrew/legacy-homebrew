require 'formula'

class Librevenge < Formula
  homepage 'http://sourceforge.net/projects/libwpd/files/librevenge/'
  url 'http://dev-www.libreoffice.org/src/librevenge-0.0.0.tar.bz2'
  sha1 '25159b8d9cd12b50fbe5b3cbe678bd5620a489a8'

  depends_on 'pkg-config' => :build
  depends_on 'boost' => :build

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--disable-werror",
                          "--disable-tests",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
