require 'formula'

class Inkscape < Formula
  homepage 'http://inkscape.org/'
  url 'https://downloads.sourceforge.net/project/inkscape/inkscape/0.48.4/inkscape-0.48.4.tar.gz'
  sha1 'ce453cc9aff56c81d3b716020cd8cc7fa1531da0'

  head do
    url 'lp:inkscape/0.48.x', :using => :bzr

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

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
  depends_on 'poppler' => :optional
  depends_on 'hicolor-icon-theme'

  fails_with :clang unless build.head?

  def install
    if build.head?
      system "./autogen.sh"
      ENV.cxx11
    end

    args = [ "--disable-dependency-tracking",
             "--prefix=#{prefix}",
             "--enable-lcms" ]
    args << "--disable-poppler-cairo" if build.without? "poppler"
    system "./configure", *args

    system "make install"
  end

  test do
    system "#{bin}/inkscape", "-V"
  end
end
