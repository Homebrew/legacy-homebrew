require 'formula'

class Hdf5 < Formula
  homepage 'http://www.hdfgroup.org/HDF5'
  url 'http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.10.tar.bz2'
  sha1 '867a91b75ee0bbd1f1b13aecd52e883be1507a2c'

  depends_on 'szip'
  depends_on 'gfortran'
  depends_on 'openmpi'


  # TODO - warn that these options conflict

  def install
    args = %W[
      CC=mpicc
      FC=mpif90
      CXX=mpicxx
      --prefix=#{prefix}
      --enable-production
      --enable-fortran 
      --enable-parallel 
      --with-szlib=/usr/local/lib 
      --with-zlib=/usr/local/lib 
      --enable-shared
      --enable-static

    ]

    #system "env CC=mpicc"
    #system "env FC=mpif90"
    #system "env CXX=mpicxx" 
    #system "./configure", args 
    #--prefix=/usr/local/Cellar/hdf5/1.8.10 --enable-production --enable-fortran --enable-parallel --with-szlib=/usr/local/lib --with-zlib=/usr/local/lib --enable-shared --enable-static"
    system "./configure CC=mpicc FC=mpif90 CXX=mpicxx --prefix=/usr/local/Cellar/hdf5/1.8.10 --enable-production --enable-fortran --enable-parallel --with-szlib=/usr/local/lib --with-zlib=/usr/local/lib --enable-shared --enable-static"
    system "make -j8" 
    system "make install"
  end
end
