require 'formula'

class LibsvgCairo < Formula
  url 'http://cairographics.org/snapshots/libsvg-cairo-0.1.6.tar.gz'
  homepage 'http://cairographics.org/'
  md5 'd79da7b3a60ad8c8e4b902c9b3563047'

  depends_on 'pkg-config' => :build
  depends_on 'libsvg'
  depends_on :libpng
  depends_on :cairo

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
  end
end
