require 'formula'

class Gwyddion < Formula
  homepage 'http://gwyddion.net/'
  url 'http://downloads.sourceforge.net/project/gwyddion/gwyddion/2.30/gwyddion-2.30.tar.xz'
  sha1 'd1260b6ec903e94533d9ff339b56833a0a405688'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
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
