class LuaRequirement < Requirement
  fatal true
  default_formula 'lua'
  satisfy { which 'lua' }
end

class Gnuplot < Formula
  homepage 'http://www.gnuplot.info'
  url 'https://downloads.sourceforge.net/project/gnuplot/gnuplot/4.6.6/gnuplot-4.6.6.tar.gz'
  sha256 '1f19596fd09045f22225afbfec11fa91b9ad1d95b9f48406362f517d4f130274'

  bottle do
    revision 1
    sha1 "c6a2e3f30495c1bd790ea5091f40b7644d695112" => :yosemite
    sha1 "03d507d87eedd8c4bf3e460931081a10403f379d" => :mavericks
    sha1 "24618fd48a6d5fa2f69843da8ac2aaa8d631ff48" => :mountain_lion
  end

  head do
    url ":pserver:anonymous:@gnuplot.cvs.sourceforge.net:/cvsroot/gnuplot", :using => :cvs

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option 'pdf',    'Build the PDF terminal using pdflib-lite'
  option 'wx',     'Build the wxWidgets terminal using pango'
  option 'qt',     'Build the Qt4 terminal'
  option 'cairo',  'Build the Cairo based terminals'
  option 'nolua',  'Build without the lua/TikZ terminal'
  option 'nogd',   'Build without gd support'
  option 'tests',  'Verify the build with make check (1 min)'
  option 'without-emacs', 'Do not build Emacs lisp files'
  option 'latex',  'Build with LaTeX support'
  option 'with-aquaterm', 'Build with AquaTerm support'

  deprecated_option "with-x" => "with-x11"

  depends_on 'pkg-config' => :build
  depends_on LuaRequirement unless build.include? 'nolua'
  depends_on 'readline'
  depends_on "libpng"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "fontconfig"
  depends_on 'pango'       if build.include? 'cairo' or build.include? 'wx'
  depends_on :x11 => :optional
  depends_on 'pdflib-lite' if build.include? 'pdf'
  depends_on 'gd'          unless build.include? 'nogd'
  depends_on 'wxmac'       if build.include? 'wx'
  depends_on 'qt'          if build.include? 'qt'
  depends_on :tex          if build.include? 'latex'

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

    args << "--with-pdf=#{pdflib}" if build.include? 'pdf'
    args << '--with' + ((build.include? 'nogd') ? 'out-gd' : "-gd=#{gd}")
    args << '--disable-wxwidgets' unless build.include? 'wx'
    args << '--without-cairo'     unless build.include? 'cairo'
    args << '--enable-qt'             if build.include? 'qt'
    args << '--without-lua'           if build.include? 'nolua'
    args << '--without-lisp-files'    if build.without? "emacs"
    args << (build.with?('aquaterm') ? '--with-aquaterm' : '--without-aquaterm')

    if build.with? "x11"
      args << "--with-x"
    else
      args << "--without-x"
    end

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
