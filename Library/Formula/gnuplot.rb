class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.0.1/gnuplot-5.0.1.tar.gz"
  sha256 "7cbc557e71df581ea520123fb439dea5f073adcc9010a2885dc80d4ed28b3c47"

  bottle do
    revision 1
    sha256 "964f6fc53e9c698e1b5c198ef38a1dabd7f3c404c5f850e29364f76ae4bf48fb" => :el_capitan
    sha256 "083a5efbc783c1375d549c89a15c6ec77f6a319be8ec08b5217b368356ae8270" => :yosemite
    sha256 "fa1003970c98d29f3c85cf646753603cfe89c428dba78b26733ae39a3bea4b99" => :mavericks
    sha256 "e8b857d4951c4ceaae42d792be9685dfe4a33387e49a7e42987efb85d51d892a" => :mountain_lion
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
  depends_on "fontconfig"
  depends_on "gd" => :recommended
  depends_on "lua" => :recommended
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "readline"
  depends_on "pango" if (build.with? "cairo") || (build.with? "wxmac")
  depends_on "pdflib-lite" => :optional
  depends_on "qt" => :optional
  depends_on "wxmac" => :optional
  depends_on :tex if build.with? "latex"
  depends_on :x11 => :optional

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

    if build.with? "qt"
      args << "--with-qt"
    else
      args << "--with-qt=no"
    end

    args << "--without-lua" if build.without? "lua"
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
    system "make", "check" if build.with?("tests") || build.bottle?
    system "make", "install"
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

  test do
    system "#{bin}/gnuplot", "-e", <<-EOS.undent
      set terminal png;
      set output "#{testpath}/image.png";
      plot sin(x);
    EOS
    File.exist? testpath/"image.png"
  end
end
