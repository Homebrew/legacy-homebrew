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

class Octave < Formula
  url 'ftp://ftp.gnu.org/gnu/octave/octave-3.4.0.tar.bz2'
  homepage 'http://www.gnu.org/software/octave/index.html'
  sha1 '936a8fc962abd96e7568fb5909ec2a4d7997a1a8'

  depends_on 'pkg-config' => :build
  depends_on 'gnu-sed' => :build
  depends_on 'texinfo' => :build     # OS X's makeinfo won't work for this

  depends_on 'fftw'
  # there is an incompatibility between gfortran and Apple's BLAS as of 10.6.6:
  #   http://www.macresearch.org/lapackblas-fortran-106
  # we can work around it using dotwrp
  depends_on 'dotwrp'
  # octave refuses to work with BSD readline, so it's either this or --disable-readline
  depends_on 'readline'

  # additional features
  depends_on 'suite-sparse'
  depends_on 'glpk'
  # test for presence of GraphicsMagick++ relies on pkg-config
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

    unless no_magick? or quiet_system "#{HOMEBREW_PREFIX}/bin/pkg-config", "--exists", "GraphicsMagick++"
      onoe <<-EOS.undent
        GraphicsMagick was installed without its C++ libraries. Please reinstall
        GraphicsMagick with the option "--with-magick-plus-plus"; otherwise, install
        Octave with option "--without-graphicsmagick".
      EOS
      exit 1
    end

    fltk = Formula.factory('fltk')
    unless no_native? or fltk.installed_prefix.to_s !~ /1.1.10$/
      onoe <<-EOS.undent
        fltk 1.1.10 is too old to be used with Octave. Please reinstall ftlk with
        the option "--HEAD"; otherwise, install Octave with option "--without-fltk".
      EOS
      exit 1
    end

    # yes, compiling octave takes a long time, but using -O2 gives negligible savings
    # build time with -O2: user 58m5.295s   sys 7m29.064s
    # build time with -O3: user 58m58.054s  sys 7m52.221s
    ENV.m64 if Hardware.is_64_bit?
    ENV.append_to_cflags "-D_REENTRANT"
    ENV.x11

    # as per the caveats in the gfortran formula:
    ENV["FC"] = ENV["F77"] = "#{HOMEBREW_PREFIX}/bin/gfortran"
    ENV["FFLAGS"] = ENV["FCFLAGS"] = ENV["CFLAGS"]

    # almost everything is autodetected, but dotwrp must be linked before Accelerate
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-blas=-ldotwrp -framework Accelerate"
    system "make all"
    system "make check" if run_tests?
    system "make install"
    prefix.install "test/fntests.log" if run_tests?
  end

  def caveats
    brew_caveats = <<-EOS.undent
      To install, you will need custom installs of fltk and graphicsmagick:
          brew install --HEAD fltk
          brew install graphicsmagick --with-magick-plus-plus

      To omit these features, see "brew options octave"

    EOS

    native_caveats = <<-EOS.undent
      Octave 3.4.0 supports "native" plotting using OpenGL and FLTK. You can activate
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
    s = brew_caveats + s
  end

end
