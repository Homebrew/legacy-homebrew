require 'formula'

class Gromacs < Formula
  homepage 'http://www.gromacs.org/'
  url 'http://www.scalalife.eu/system/files/Gromacs-4.6-ScalaLife2012.tgz'
  sha1 '9f2d7b6bd6ffaee8ffd421d891785e682fabf3f2'

  option 'enable-mpi', "Enables MPI support"
  option 'enable-double',"Enables double precision"

  depends_on :x11
  depends_on 'fftw'
  depends_on 'cmake'

  def install
    #args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}"]
    #args << "--enable-mpi" if build.include? 'enable-mpi'
    #args << "--enable-double" if build.include? 'enable-double'

    system "mkdir build"
    system "cd build"
    system "cmake ../gromacs-4.6-ScalaLife-120831 -DCMAKE_INSTALL_PREFIX=#{prefix} -DGMX_GPU=OFF -DGMX_OPENMP=OFF"
    system "make -j2"
    #ENV.j2
    system "make install"
  end
end
