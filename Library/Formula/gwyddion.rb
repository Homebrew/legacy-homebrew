require 'formula'

class Gwyddion < Formula
  homepage 'http://gwyddion.net/'
  url 'https://downloads.sourceforge.net/project/gwyddion/gwyddion/2.36/gwyddion-2.36.tar.xz'
  sha1 '0e81bbc3dbb0aadf5ab2ecb0606bd79a12681be2'

  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'libxml2'
  depends_on 'fftw'
  depends_on 'gtkglext'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-desktop-file-update",
                          "--prefix=#{prefix}",
                          "--with-html-dir=#{doc}"
    system "make install"
  end
end
