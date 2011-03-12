require 'formula'

class Gwyddion <Formula
  url 'http://downloads.sourceforge.net/project/gwyddion/gwyddion/2.23/gwyddion-2.23.tar.bz2'
  homepage 'http://gwyddion.net/'
  md5 '24913aa2e44ed0791287e2b09fbe354f'

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
