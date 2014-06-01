require 'formula'

class Libvisio < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/libvisio/'
  url 'http://dev-www.libreoffice.org/src/libvisio-0.1.0.tar.xz'
  sha1 'c82e5c7ad25e513c268032cda9febd01b8879504'

  depends_on 'pkg-config' => :build
  depends_on 'boost' => :build
  depends_on 'libwpd'
  depends_on 'libwpg'
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
