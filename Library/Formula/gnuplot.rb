require 'formula'

class LuaRequirement < Requirement
  fatal true
  default_formula 'lua'
  satisfy { which 'lua' }
end

class Gnuplot < Formula
  homepage 'http://www.gnuplot.info'
  url 'https://downloads.sourceforge.net/project/gnuplot/gnuplot/4.6.5/gnuplot-4.6.5.tar.gz'
  sha256 'e550f030c7d04570e89c3d4e3f6e82296816508419c86ab46c4dd73156519a2d'

  head do
    url 'cvs://:pserver:anonymous:@gnuplot.cvs.sourceforge.net:/cvsroot/gnuplot:gnuplot'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  option 'with-pdf',    'Build the PDF terminal using pdflib-lite'
  option 'with-wx',     'Build the wxWidgets terminal using pango'
  option 'with-x', 'Build the X11 terminal'
  option 'with-qt',     'Build the Qt4 terminal'
  option 'with-cairo',  'Build the Cairo based terminals'
  option 'without-lua',  'Build without the lua/TikZ terminal'
  option 'without-gd',   'Build without gd support'
  option 'with-tests',  'Verify the build with make check (1 min)'
  option 'without-emacs', 'Do not build Emacs lisp files'
  option 'with-latex',  'Build with LaTeX support'
  option 'without-aquaterm', 'Do not build AquaTerm support'

  depends_on 'pkg-config' => :build
  depends_on LuaRequirement if build.with? 'lua'
  depends_on 'readline'
  depends_on "libpng"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "fontconfig"
  depends_on 'pango'       if build.with? 'cairo' or build.with? 'wx'
  depends_on :x11          if build.with? "x"
  depends_on 'pdflib-lite' if build.with? 'pdf'
  depends_on 'gd'          if build.without? 'gd'
  depends_on 'wxmac'       if build.with? 'wx'
  depends_on 'qt'          if build.with? 'qt'
  depends_on :tex          if build.with? 'latex'

  def install
    if build.with? "aquaterm"
      # Add "/Library/Frameworks" to the default framework search path, so that an
      # installed AquaTerm framework can be found. Brew does not add this path
      # when building against an SDK (Nov 2013).
      ENV.prepend "CPPFLAGS", "-F/Library/Frameworks"
      ENV.prepend "LDFLAGS", "-F/Library/Frameworks"

      unless build.head?
        # Fix up Gnuplot v4.6.x to accommodate framework style linking. This is
        # required with a standard install of AquaTerm 1.1.1 and is supported under
        # earlier versions of AquaTerm. Refer:
        # https://github.com/AquaTerm/AquaTerm/blob/v1.1.1/aquaterm/ReleaseNotes#L1-11
        # https://github.com/AquaTerm/AquaTerm/blob/v1.1.1/aquaterm/INSTALL#L7-15
        inreplace "configure", "-laquaterm", "-framework AquaTerm"
        inreplace "term/aquaterm.trm", "<aquaterm/AQTAdapter.h>", "<AquaTerm/AQTAdapter.h>"
      end
    elsif !build.head?
      inreplace "configure", "-laquaterm", ""
    end

    # Help configure find libraries
    readline = Formula["readline"].opt_prefix
    pdflib = Formula["pdflib-lite"].opt_prefix
    gd = Formula["gd"].opt_prefix

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-readline=#{readline}
    ]

    args << "--with-pdf=#{pdflib}" if build.with? 'pdf'
    args << '--with' + ((build.without? 'gd') ? 'out-gd' : "-gd=#{gd}")
    args << '--disable-wxwidgets' if build.without? 'wx'
    args << '--without-cairo'     if build.without? 'cairo'
    args << '--enable-qt'             if build.with? 'qt'
    args << '--without-lua'           if build.without? 'lua'
    args << '--without-lisp-files'    if build.without? "emacs"
    args << (build.with?('aquaterm') ? '--with-aquaterm' : '--without-aquaterm')

    if build.with? "x"
      args << "--with-x"
    else
      args << "--without-x"
    end

    if build.with? 'latex'
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
    system 'make check' if build.with? 'tests' # Awesome testsuite
    system "make install"
  end

  test do
    system "#{bin}/gnuplot", "-e", <<-EOS.undent
        set terminal png;
        set output "#{testpath}/image.png";
        plot sin(x);
    EOS
    assert (testpath/"image.png").exist?
  end

  def caveats
    if build.with? "aquaterm"
      <<-EOS.undent
        AquaTerm support will only be built into Gnuplot if the standard AquaTerm
        package from SourceForge has already been installed onto your system.
        If you subsequently remove AquaTerm, you will need to uninstall and then
        reinstall Gnuplot.
      EOS
    end
  end
end
