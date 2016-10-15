require 'formula'

class Libmspub < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/libmspub/'
  url 'http://dev-www.libreoffice.org/src/libmspub-0.1.0.tar.xz'
  sha1 'f3e2106613f37620b7f8f77bce6392eca72f3e76'

  depends_on 'pkg-config' => :build
  depends_on 'boost' => :build
  depends_on 'libwpg' => :build
  depends_on 'libwpd'
  depends_on 'icu4c'
  depends_on 'librevenge'

  def install
    system "./configure", "--without-docs",
                          "-disable-dependency-tracking",
                          "--enable-static=no",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
