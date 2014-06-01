require 'formula'

class Libmwaw < Formula
  homepage 'http://sourceforge.net/projects/libmwaw/'
  url 'http://dev-www.libreoffice.org/src/libmwaw-0.3.1.tar.bz2'
  sha1 '02b6949b5d9fcd7ec3b0b686b1f8ab921fcdf033'

  depends_on 'pkg-config' => :build
  depends_on 'boost' => :build
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
