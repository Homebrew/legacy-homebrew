require 'formula'

class Libetonyek < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/libetonyek/'
  url 'http://dev-www.libreoffice.org/src/libetonyek-0.1.0.tar.xz'
  sha1 'defb93362313da19976da5eb14d9fead99e5b473'

  depends_on 'pkg-config' => :build
  depends_on 'boost' => :build
  depends_on 'libwpd'
  depends_on 'librevenge'

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
