require 'formula'

class Gwyddion < Formula
  homepage 'http://gwyddion.net/'
  url 'http://downloads.sourceforge.net/project/gwyddion/gwyddion/2.33/gwyddion-2.33.tar.xz'
  sha1 'bffddf12be9e96f8a2110cb40e035b60842031c7'

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
