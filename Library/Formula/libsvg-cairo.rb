require 'formula'

class LibsvgCairo < Formula
  homepage 'http://cairographics.org/'
  url 'http://cairographics.org/snapshots/libsvg-cairo-0.1.6.tar.gz'
  sha1 'c7bf131b59e8c00a80ce07c6f2f90f25a7c61f81'
  revision 1

  depends_on 'pkg-config' => :build
  depends_on 'libsvg'
  depends_on 'libpng'
  depends_on 'cairo'

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
