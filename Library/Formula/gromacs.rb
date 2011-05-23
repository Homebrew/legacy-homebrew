require 'formula'

class Gromacs < Formula
  url 'ftp://ftp.gromacs.org/pub/gromacs/gromacs-4.5.3.tar.gz'
  homepage 'http://www.gromacs.org/'
  md5 'd5911585cd0e0b996dbbdcfb4c3bcf6b'

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
