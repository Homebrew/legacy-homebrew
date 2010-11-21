require 'formula'

class Octave <Formula
  url 'ftp://ftp.octave.org/pub/octave/octave-3.2.4.tar.bz2'
  homepage 'http://www.gnu.org/software/octave/index.html'
  md5 '608196657f4fa010420227b77333bb71'

  depends_on 'qhull'
  depends_on 'fftw'
  depends_on 'pcre'
  depends_on 'gnuplot'
  depends_on 'gnu-sed'
  depends_on 'readline'
  depends_on 'gfortran'

  ENV["FC"] = ENV["F77"] = "#{HOMEBREW_PREFIX}/bin/gfortran"
  ENV["FFLAGS"] = ENV["FCFLAGS"] = ENV["CFLAGS"]
  ENV["CXXFLAGS"] = "#{ENV["CXXFLAGS"]} -D_REENTRANT"

  def install

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make octave-bug"
    system "make octave-config"
    system "make mkoctfile"
    system "make install"

  end
end
