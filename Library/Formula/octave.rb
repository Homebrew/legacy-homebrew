require 'formula'

def no_magick?
  ARGV.include? '--without-graphicsmagick'
end

def no_native?
  ARGV.include? '--without-fltk'
end

def run_tests?
  ARGV.include? '--test'
end

def snow_leopard_64?
  # 64 bit builds on 10.6 require some special handling.
  MACOS_VERSION == 10.6 and MacOS.prefer_64_bit?
end

class Octave < Formula
  homepage 'http://www.gnu.org/software/octave/index.html'
  url 'http://ftpmirror.gnu.org/octave/octave-3.6.1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/octave/octave-3.6.1.tar.bz2'
  md5 'b543dd5ca743cba8c1d3474b1b99ae41'

  depends_on 'pkg-config' => :build
  depends_on 'gnu-sed' => :build
  depends_on 'texinfo' => :build     # OS X's makeinfo won't work for this

  depends_on 'fftw'
  # When building 64-bit binaries on Snow Leopard, there are naming issues with
  # the dot product functions in the BLAS library provided by Apple's
  # Accelerate framework. See the following thread for the gory details:
  #
  #   http://www.macresearch.org/lapackblas-fortran-106
  #
  # We can work around the issues using dotwrp.
  depends_on 'dotwrp' if snow_leopard_64?
  # octave refuses to work with BSD readline, so it's either this or --disable-readline
  depends_on 'readline'
  depends_on 'curl' if MacOS.leopard? # Leopard's libcurl is too old

  # additional features
  depends_on 'suite-sparse'
  depends_on 'glpk'
  depends_on 'graphicsmagick' unless no_magick?
  depends_on 'hdf5'
  depends_on 'pcre'
  depends_on 'fltk' unless no_native?
  depends_on 'qhull'
  depends_on 'qrupdate'

  # required for plotting if we don't have native graphics
  depends_on 'gnuplot' if no_native?

  def options
    [
      ['--without-graphicsmagick', 'Compile without GraphicsMagick'],
      ['--without-fltk', 'Compile without fltk (disables native graphics)'],
      ['--test', 'Run tests before installing'],
    ]
  end

  def install
    ENV.fortran

    # yes, compiling octave takes a long time, but using -O2 gives negligible savings
    # build time with -O2: user 58m5.295s   sys 7m29.064s
    # build time with -O3: user 58m58.054s  sys 7m52.221s
    ENV.m64 if MacOS.prefer_64_bit?
    ENV.append_to_cflags "-D_REENTRANT"
    ENV.x11

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      # Cant use `-framework Accelerate` because `mkoctfile`, the tool used to
      # compile extension packages, can't parse `-framework` flags.
      "--with-blas=#{'-ldotwrp ' if snow_leopard_64?}-Wl,-framework -Wl,Accelerate"
    ]
    args << "--without-framework-carbon" if MacOS.lion?

    system "./configure", *args
    system "make all"
    system "make check 2>&1 | tee make-check.log" if run_tests?
    system "make install"
    prefix.install ["test/fntests.log", "make-check.log"] if run_tests?
  end

  def caveats
    native_caveats = <<-EOS.undent
      Octave supports "native" plotting using OpenGL and FLTK. You can activate
      it for all future figures using the Octave command

          graphics_toolkit ("fltk")

      or for a specific figure handle h using

          graphics_toolkit (h, "fltk")

      Otherwise, gnuplot is still used by default, if available.
    EOS

    gnuplot_caveats = <<-EOS.undent
      When plotting with gnuplot, you should set "GNUTERM=x11" before running octave;
      if you are using Aquaterm, use "GNUTERM=aqua".
    EOS

    s = gnuplot_caveats
    s = native_caveats + s unless no_native?
  end
end
