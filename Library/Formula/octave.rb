require 'formula'

class Octave <Formula
  url 'ftp://ftp.octave.org/pub/octave/octave-3.2.4.tar.gz'
  homepage 'http://www.gnu.org/software/octave/index.html'
  md5 '90c39fa9e241ad2e978bcee4682a2ba9'

  depends_on 'readline'
  depends_on 'gnuplot'
  depends_on 'gfortran'
  depends_on 'gnu-sed'

  depends_on 'fftw'
  depends_on 'ftgl'
  depends_on 'ghostscript'
  depends_on 'glpk'
  depends_on 'hdf5'
  depends_on 'metis'
  depends_on 'pcre'

  def install
    unless TeX_installed?
      onoe <<-EOS.undent
        Octave requires a TeX/LaTeX installation; aborting now.
        You can obtain the TeX distribution for Mac OS X from
            http://www.tug.org/mactex/
      EOS
      exit 1
    end

    ENV.m64 if Hardware.is_64_bit?
    ENV.O2
    ENV.append_to_cflags "-D_REENTRANT"
    ENV.x11

    system "./configure", "--prefix=#{prefix}", "--enable-shared",
      "--enable-dl", "--with-hdf5", "--with-fftw",
      "--enable-static", "--enable-readline",
      "--with-zlib", "--with-glpk", "--with-curl",
      "--with-lapack", "--with-umfpack", "--with-colamd", "--with-ccolamd",
      "--with-cholmod", "--with-cxsparse"
    system "make -j 1 doc"
    system "make all"
    system "make install"
  end

  def caveats
    "Set GNUTERM=x11 before running octave for graphing with gnuplot."
  end

  private

  def TeX_installed?
    `which tex` != ''
  end
end
