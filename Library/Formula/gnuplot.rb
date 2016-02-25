class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.0.3/gnuplot-5.0.3.tar.gz"
  sha256 "5f6ee35f3f22014058e999911934bfa9db28e02a2722a7001c192cd182b8c715"

  bottle do
    sha256 "e429bd5f40c8611b5e2e7c286124fc9da2547bfb5d80aed32f5e1d4dbd3481ec" => :el_capitan
    sha256 "26baf173eb97e86686dbaa1770b59b91c3b7d91049cd4e213b87c2ba7ea8b820" => :yosemite
    sha256 "bb3700adc73329b2f4e0a5d423a607a00a52ac3ddab6070121a7fb336a8b16bc" => :mavericks
  end

  head do
    url ":pserver:anonymous:@gnuplot.cvs.sourceforge.net:/cvsroot/gnuplot", :using => :cvs

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-cairo",  "Build the Cairo based terminals"
  option "without-lua",  "Build without the lua/TikZ terminal"
  option "with-test",  "Verify the build with make check"
  option "without-emacs", "Do not build Emacs lisp files"
  option "with-wxmac", "Build wxmac support. Need with-cairo to build wxt terminal"
  option "with-tex",  "Build with LaTeX support"
  option "with-aquaterm", "Build with AquaTerm support"

  deprecated_option "with-x" => "with-x11"
  deprecated_option "pdf" => "with-pdflib-lite"
  deprecated_option "wx" => "with-wxmac"
  deprecated_option "qt" => "with-qt"
  deprecated_option "nogd" => "without-gd"
  deprecated_option "cairo" => "with-cairo"
  deprecated_option "nolua" => "without-lua"
  deprecated_option "tests" => "with-test"
  deprecated_option "with-tests" => "with-test"
  deprecated_option "latex" => "with-tex"
  deprecated_option "with-latex" => "with-tex"

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "gd" => :recommended
  depends_on "lua" => :recommended
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "readline"
  depends_on "pango" if build.with?("cairo") || build.with?("wxmac")
  depends_on "pdflib-lite" => :optional
  depends_on "qt" => :optional
  depends_on "wxmac" => :optional
  depends_on :tex => :optional
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

    if build.with? "tex"
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
    system "make", "check" if build.with?("test") || build.bottle?
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
