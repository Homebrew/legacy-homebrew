class LuaRequirement < Requirement
  fatal true
  default_formula "lua"
  satisfy { which "lua" }
end

class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.0.0/gnuplot-5.0.0.tar.gz"
  mirror "http://ftp.cstug.cz/pub/CTAN/graphics/gnuplot/5.0.0/gnuplot-5.0.0.tar.gz"
  sha256 "417d4bc5bc914a60409bb75cf18dd14f48b07f53c6ad3c4a4d3cd9a8d7370faf"

  bottle do
    sha1 "ba387ee75f15b1220f1c77469609841cb7155f83" => :yosemite
    sha1 "3a4cd6881a231c5e0da155147be85c053a1f2faa" => :mavericks
    sha1 "e35173ded72e0ce48acc80cd72981679c32960c7" => :mountain_lion
  end

  head do
    url ":pserver:anonymous:@gnuplot.cvs.sourceforge.net:/cvsroot/gnuplot", :using => :cvs

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-cairo",  "Build the Cairo based terminals"
  option "without-lua",  "Build without the lua/TikZ terminal"
  option "with-tests",  "Verify the build with make check"
  option "without-emacs", "Do not build Emacs lisp files"
  option "with-wxmac", "Build wxmac support. Need with-cairo to build wxt terminal"
  option "with-latex",  "Build with LaTeX support"
  option "with-aquaterm", "Build with AquaTerm support"

  deprecated_option "with-x" => "with-x11"
  deprecated_option "pdf" => "with-pdflib-lite"
  deprecated_option "wx" => "with-wxmac"
  deprecated_option "qt" => "with-qt"
  deprecated_option "nogd" => "without-gd"
  deprecated_option "cairo" => "with-cairo"
  deprecated_option "nolua" => "without-lua"
  deprecated_option "tests" => "with-tests"
  deprecated_option "latex" => "with-latex"

  depends_on "pkg-config" => :build
  depends_on LuaRequirement if build.with? "lua"
  depends_on "readline"
  depends_on "libpng"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "fontconfig"
  depends_on "pango"       if (build.with? "cairo") || (build.with? "wxmac")
  depends_on :x11 => :optional
  depends_on "pdflib-lite" => :optional
  depends_on "gd" => :recommended
  depends_on "wxmac" => :optional
  depends_on "qt" => :optional
  depends_on :tex          if build.with? "latex"

  def install
    if build.with? "aquaterm"
      # Add "/Library/Frameworks" to the default framework search path, so that an
      # installed AquaTerm framework can be found. Brew does not add this path
      # when building against an SDK (Nov 2013).
      ENV.prepend "CPPFLAGS", "-F/Library/Frameworks"
      ENV.prepend "LDFLAGS", "-F/Library/Frameworks"
    end

    # Help configure find libraries
    pdflib = Formula["pdflib-lite"].opt_prefix
    gd = Formula["gd"].opt_prefix

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
    ]

    args << "--with-pdf=#{pdflib}" if build.with? "pdflib-lite"
    args << ((build.with? "gd") ? "--with-gd=#{gd}" : "--without-gd")

    if build.without? "wxmac"
      args << "--disable-wxwidgets"
      args << "--without-cairo" if build.without? "cairo"
    end

    args << "--with-qt" if build.with? "qt"
    args << "--without-lua"        if build.without? "lua"
    args << "--without-lisp-files" if build.without? "emacs"
    args << ((build.with? "aquaterm") ? "--with-aquaterm" : "--without-aquaterm")
    args << ((build.with? "x11") ? "--with-x" : "--without-x")

    if build.with? "latex"
      args << "--with-latex"
      args << "--with-tutorial"
    else
      args << "--without-latex"
      args << "--without-tutorial"
    end

    system "./prepare" if build.head?
    system "./configure", *args
    ENV.j1 # or else emacs tries to edit the same file with two threads
    system "make"
    system "make", "check" if build.with? "tests" # Awesome testsuite
    system "make", "install"
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
