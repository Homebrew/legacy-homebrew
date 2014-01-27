require 'formula'

class LuaRequirement < Requirement
  fatal true
  default_formula 'lua'

  satisfy { which 'lua' }
end

class Gnuplot < Formula
  homepage 'http://www.gnuplot.info'
  url 'http://downloads.sourceforge.net/project/gnuplot/gnuplot/4.6.3/gnuplot-4.6.3.tar.gz'
  sha256 'df5ffafa25fb32b3ecc0206a520f6bca8680e6dcc961efd30df34c0a1b7ea7f5'

  head do
    url 'cvs://:pserver:anonymous:@gnuplot.cvs.sourceforge.net:/cvsroot/gnuplot:gnuplot'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  option 'with-pdf',         'Build the PDF terminal using pdflib-lite'
  option 'with-wx',          'Build the wxWidgets terminal using pango'
  option 'with-x',           'Build the X11 terminal'
  option 'with-qt',          'Build the Qt4 terminal'
  option 'with-cairo',       'Build the Cairo based terminals'
  option 'without-lua',      'Build without the lua/TikZ terminal'
  option 'without-gd',       'Build without gd support'
  option 'with-tests',       'Verify the build with make check (1 min)'
  option 'without-emacs',    'Do not build Emacs lisp files'
  option 'with-latex',       'Build with LaTeX support'
  option 'without-aquaterm', 'Do not build with AquaTerm support'

  depends_on 'pkg-config' => :build
  depends_on LuaRequirement if build.with? 'lua'
  depends_on 'readline'
  depends_on 'pango'        if build.with? 'cairo' or build.with? 'wx'
  depends_on :x11           if build.with? 'x' or MacOS::X11.installed?
  depends_on 'pdflib-lite'  if build.with? 'pdf'
  depends_on 'gd'           if build.with? 'gd'
  depends_on 'wxmac'        if build.with? 'wx'
  depends_on 'qt'           if build.with? 'qt'
  depends_on :tex           if build.with? 'latex'

  def install

    if build.with? 'aquaterm'
      # Prepare AquaTerm support

      # Add '/Library/Frameworks' to the default framework search path, so that an
      # installed AquaTerm framework can be found. Brew does not add this path
      # when building against an SDK (Nov 2013).
      ENV.prepend 'CPPFLAGS', '-F/Library/Frameworks'
      ENV.prepend 'LDFLAGS',  '-F/Library/Frameworks'

      # Fix up Gnuplot v4.6.x to accommodate framework style linking. This is
      # required with a standard install of AquaTerm 1.1.1 and is supported under
      # earlier versions of AquaTerm. Refer:
      # https://github.com/AquaTerm/AquaTerm/blob/v1.1.1/aquaterm/ReleaseNotes#L1-11
      # https://github.com/AquaTerm/AquaTerm/blob/v1.1.1/aquaterm/INSTALL#L7-15

      if (version < Version.new('4.7')) && !build.head?
        # Adapt configure to use framework style in place of library style.
        # Two occurrences: one for AquaTerm detection, and one to set $LIBS for
        # make.
        inreplace 'configure', '-laquaterm', '-framework AquaTerm'

        # One import specification change.
        inreplace 'term/aquaterm.trm', '<aquaterm/AQTAdapter.h>', '<AquaTerm/AQTAdapter.h>'
      end
    else # no AquaTerm
      if (version < Version.new('4.7')) && !build.head?
        # Simply squash configure's ability to locate libaquaterm.dylib, and
        # AquaTerm support will be disabled.
        inreplace 'configure', '-laquaterm', ''
      end
    end


    # Help configure find libraries
    readline = Formula.factory 'readline'
    pdflib = Formula.factory 'pdflib-lite'
    gd = Formula.factory 'gd'

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-readline=#{readline.opt_prefix}
    ]

    args << "--with-pdf=#{pdflib.opt_prefix}" if build.with? 'pdf'
    args << '--with' + ((build.without? 'gd') ? 'out-gd' : "-gd=#{gd.opt_prefix}")
    args << '--disable-wxwidgets'  unless build.with? 'wx'
    args << '--without-cairo'      unless build.with? 'cairo'
    args << '--enable-qt'              if build.with? 'qt'
    args << '--without-lua'        unless build.with? 'lua'
    args << '--without-lisp-files' unless build.with? 'emacs'
    # Be explicit, default might not be fixed in stone. A no-op in v4.6.3 & 4.
    args << ((build.with? 'aquaterm') ? '--with-aquaterm' : '--without-aquaterm')

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

  def test
    system "#{bin}/gnuplot", "--version"
  end

  def caveats
    s = ''
    if build.with? 'aquaterm'
      s = <<-EOS.undent
        AquaTerm support will only be built into Gnuplot if the standard AquaTerm
        package from SourceForge has already been installed onto your system.
        If you subsequently remove AquaTerm, you will need to uninstall and then
        reinstall Gnuplot.
      EOS
    end
    s
  end

end
