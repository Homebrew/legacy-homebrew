require 'formula'

class Gromacs < Formula
  url 'ftp://ftp.gromacs.org/pub/gromacs/gromacs-4.5.4.tar.gz'
  homepage 'http://www.gromacs.org/'
  md5 '5013de941017e014b92d41f82c7e86d6'

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
