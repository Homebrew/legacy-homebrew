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
  depends_on 'poppler'
  depends_on 'libpng'


  fails_with :clang

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-lcms"
    system "make install"
  end

  def caveats; <<-EOS.undent
    From: http://wiki.inkscape.org/wiki/index.php/Frequently_asked_questions#Copying_and_pasting_in_Inkscape_creates_pixellated_images_instead_of_copying_the_vector_objects

    Starting with XQuartz 2.3.2, X11 has some functionality to
    exchange the content of the clipboard with OS X. But it currently
    does not know how to deal with vector images so it just captures
    the screen, i.e. creates a bitmap copy, and then pastes that. You
    need to deactivate this functionality in X11 preferences >
    Pasteboard: uncheck "Update Pasteboard when CLIPBOARD
    changes". However, this will also prevent copying text from any
    X11 application to Mac OS X ones. It will not prevent copying text
    from OS X to X11.

    Install 'brew install pstoedit' if you want to use
    Extensions->Render->LaTeX Formula.
  end

  def test
    system "#{bin}/inkscape", "-V"
  end
end
