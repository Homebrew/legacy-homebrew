require 'formula'

class Gnuplot < Formula
  homepage 'http://www.gnuplot.info'
  url 'http://downloads.sourceforge.net/project/gnuplot/gnuplot/4.6.1/gnuplot-4.6.1.tar.gz'
  sha1 '1ea21a628223159b0297ae65fe8293afd5aab3c0'

  head 'cvs://:pserver:anonymous@gnuplot.cvs.sourceforge.net:/cvsroot/gnuplot:gnuplot', :using => :cvs

  option 'pdf',    'Build the PDF terminal using pdflib-lite'
  option 'wx',     'Build the wxWidgets terminal using pango'
  option 'with-x', 'Build the X11 terminal'
  option 'qt',     'Build the Qt4 terminal'
  option 'cairo',  'Build the Cairo based terminals'
  option 'nolua',  'Build without the lua/TikZ terminal'
  option 'nogd',   'Build without gd support'
  option 'tests',  'Verify the build with make check (1 min)'
  option 'without-emacs', 'Do not build Emacs lisp files'
  option 'latex',  'Build with LaTeX support'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'pango'       if build.include? 'cairo' or build.include? 'wx'
  depends_on :x11          if build.include? 'with-x' or MacOS::X11.installed?
  depends_on 'pdflib-lite' if build.include? 'pdf'
  depends_on 'lua'         unless build.include? 'nolua'
  depends_on 'gd'          unless build.include? 'nogd'
  depends_on 'wxmac'       if build.include? 'wx'
  depends_on 'qt'          if build.include? 'qt'
  depends_on :tex          if build.include? 'latex'

  def patches
    # see discussion on this cairo issue: https://github.com/fontforge/fontforge/issues/222
    # and the gnuplot bug report: https://sourceforge.net/p/gnuplot/bugs/1223/
    DATA
  end

  def install
    # Help configure find libraries
    readline = Formula.factory 'readline'
    pdflib = Formula.factory 'pdflib-lite'
    gd = Formula.factory 'gd'

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-readline=#{readline.opt_prefix}
    ]

    args << "--with-pdf=#{pdflib.opt_prefix}" if build.include? 'pdf'
    args << '--with' + ((build.include? 'nogd') ? 'out-gd' : "-gd=#{gd.opt_prefix}")
    args << '--disable-wxwidgets' unless build.include? 'wx'
    args << '--without-cairo'     unless build.include? 'cairo'
    args << '--enable-qt'             if build.include? 'qt'
    args << '--without-lua'           if build.include? 'nolua'
    args << '--without-lisp-files'    if build.include? 'without-emacs'

    if build.include? 'latex'
      args << '--with-latex'
      args << '--with-tutorial'
    else
      args << '--without-latex'
      args << '--without-tutorial'
    end

    system './prepare' if build.head?
    system "./configure", *args
    ENV.j1 # or else emacs tries to edit the same file with two threads
    system 'make'
    system 'make check' if build.include? 'tests' # Awesome testsuite
    system "make install"
  end

  def test
    system "#{bin}/gnuplot", "--version"
  end
end

__END__
diff --git a/term/cairo.trm b/term/cairo.trm
index 48fac72..c5d110f 100644
--- a/term/cairo.trm
+++ b/term/cairo.trm
@@ -615,6 +615,7 @@ TERM_PUBLIC void cairotrm_options()
  * Is the 'main' function of the terminal. */
 void cairotrm_init()
 {
+	g_type_init();
	cairo_surface_t *surface = NULL;

	FPRINTF((stderr,"Init\n"));
