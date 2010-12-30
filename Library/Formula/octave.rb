require 'formula'

class Octave <Formula
  url 'ftp://ftp.octave.org/pub/octave/octave-3.2.4.tar.gz'
  homepage 'http://www.gnu.org/software/octave'
  md5 '90c39fa9e241ad2e978bcee4682a2ba9'

  # depends_on 'gnu-sed'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
                          "--without-x"
                          "--without-framework-carbon"
                          "--without-hdf5"
                          "--without-curl"
                          "--without-glpk"
                          "--without-blas"
                          "--without-lapack"

    system "make install"
  end
end
