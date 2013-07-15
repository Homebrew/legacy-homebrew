require 'formula'

class Gwyddion < Formula
  homepage 'http://gwyddion.net/'
  url 'http://downloads.sourceforge.net/project/gwyddion/gwyddion/2.31/gwyddion-2.31.tar.xz'
  sha1 '0e0b78970bd3c8272f69f48fc5c7180514c859a1'

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
