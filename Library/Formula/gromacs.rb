require 'formula'

class Gromacs < Formula
  homepage 'http://www.gromacs.org/'
  url 'ftp://ftp.gromacs.org/pub/gromacs/gromacs-4.5.5.tar.gz'
  md5 '6a87e7cdfb25d81afa9fea073eb28468'

  option 'enable-mpi', "Enables MPI support"
  option 'enable-double',"Enables double precision"

  depends_on 'fftw'

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-mpi" if build.include? 'enable-mpi'
    args << "--enable-double" if build.include? 'enable-double'

    system "./configure", *args
    system "make"
    ENV.j1
    system "make install"
  end
end
