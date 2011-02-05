require 'formula'

class Gwyddion <Formula
  url 'http://downloads.sourceforge.net/project/gwyddion/gwyddion/2.21/gwyddion-2.21.tar.bz2'
  homepage 'http://gwyddion.net/'
  md5 '7330a22460743c9da8dceec03f7924e9'

  depends_on 'gtk+'
  depends_on 'libxml2'
  depends_on 'fftw'
  depends_on 'gtkglext'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-desktop-file-update",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
