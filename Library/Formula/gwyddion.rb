require 'formula'

class Gwyddion < Formula
  homepage 'http://gwyddion.net/'
  url 'http://downloads.sourceforge.net/project/gwyddion/gwyddion/2.28/gwyddion-2.28.tar.xz'
  sha1 '9f93b236f39694a9d0c4e162a20ace963783ccea'

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
