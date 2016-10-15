require 'formula'

class Libfreehand < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/libfreehand/'
  url 'http://dev-www.libreoffice.org/src/libfreehand-0.1.0.tar.xz'
  sha1 '049008cc7e0aebd781cd3e9f56c931e6e147a4eb'

  depends_on 'pkg-config' => :build
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
