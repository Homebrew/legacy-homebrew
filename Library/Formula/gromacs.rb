require 'formula'

class Gromacs < Formula
  url 'ftp://ftp.gromacs.org/pub/gromacs/gromacs-4.5.5.tar.gz'
  homepage 'http://www.gromacs.org/'
  md5 '6a87e7cdfb25d81afa9fea073eb28468'

  depends_on 'fftw'

  def options
    [
      ['--enable-mpi', "Enables MPI support"],
      ['--enable-double',"Enables double precision"]
    ]
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-mpi" if ARGV.include? '--enable-mpi'
    args << "--enable-double" if ARGV.include? '--enable-double'

    system "./configure", *args
    system "make"
    ENV.j1
    system "make install"
  end
end
