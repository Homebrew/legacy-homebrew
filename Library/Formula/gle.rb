require 'formula'

class Gle < Formula
  url 'http://downloads.sourceforge.net/glx/gle-graphics-4.2.3bf-src.tar.gz'
  version '4.2.3b'
  homepage 'http://glx.sourceforge.net/'
  md5 '5884a1cbf7a0fe5d3a18a235d10f64a8'

  depends_on 'pkg-config' => :build
  depends_on 'jpeg' => :optional
  depends_on 'libtiff' => :optional

  def install
    ENV.x11

    arch = MacOS.prefer_64_bit? ? "x86_64" : "i386"
    system "./configure", "--prefix=#{prefix}",
                          "--with-arch=#{arch}",
                          "--without-qt"

    inreplace 'Makefile',"MKDIR_P", "mkdir -p"

    system "make"
    ENV.deparallelize
    system "make install"
  end
end
