require 'formula'

class Inkscape < Formula
  homepage 'http://inkscape.org/'
  url 'http://downloads.sourceforge.net/project/inkscape/inkscape/0.48.4/inkscape-0.48.4.tar.gz'
  sha1 'ce453cc9aff56c81d3b716020cd8cc7fa1531da0'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'boost-build' => :build
  depends_on 'gettext'
  depends_on 'bdw-gc'
  depends_on 'glibmm'
  depends_on 'gtkmm'
  depends_on 'gsl'
  depends_on 'boost'
  depends_on 'popt'
  depends_on 'little-cms'
  depends_on 'cairomm'
  depends_on 'pango'
  depends_on :x11

  fails_with :clang

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-lcms",
                          "--disable-poppler-cairo"
    system "make install"
  end

  def test
    system "#{bin}/inkscape", "-V"
  end
end
