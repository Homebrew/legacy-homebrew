require 'formula'

class LibsvgCairo <Formula
  url 'http://cairographics.org/snapshots/libsvg-cairo-0.1.6.tar.gz'
  homepage 'http://cairographics.org/'
  md5 'd79da7b3a60ad8c8e4b902c9b3563047'
  version '0.1.6'

  depends_on 'pkg-config' => :build
  depends_on 'libpng'
  depends_on 'libsvg'
  depends_on 'cairo' if MACOS_VERSION < 10.6

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
  end
end
