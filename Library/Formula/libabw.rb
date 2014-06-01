require 'formula'

class Libabw < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/libabw/'
  url 'http://dev-www.libreoffice.org/src/libabw-0.1.0.tar.xz'
  sha1 '99bbf0e8c2084fa9db2a3998fc4c867123fbed69'

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
