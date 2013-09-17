require 'formula'

class Gwyddion < Formula
  homepage 'http://gwyddion.net/'
  url 'http://downloads.sourceforge.net/project/gwyddion/gwyddion/2.32/gwyddion-2.32.tar.xz'
  sha1 'dfe72a4537de2ccfb36077812e4e98700ec52ede'

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
