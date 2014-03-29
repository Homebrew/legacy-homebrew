require 'formula'

class Gwyddion < Formula
  homepage 'http://gwyddion.net/'
  url 'https://downloads.sourceforge.net/project/gwyddion/gwyddion/2.35/gwyddion-2.35.tar.xz'
  sha1 'c58027bdedfc5615bac134b2178197869c52c950'

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
