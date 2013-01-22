require 'formula'

class Hdf5 < Formula
  homepage 'http://www.hdfgroup.org/HDF5'
  url 'http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.10.tar.bz2'
  sha1 '867a91b75ee0bbd1f1b13aecd52e883be1507a2c'

  depends_on 'szip'
  # I havent been able to get openmpi/hdf5 to work correctly with clang on OSX-10.8
  
   depends_on 'openmpi'=>'force-gcc' if build.include? 'enable-parallel'

  # TODO - warn that these options conflict
  option 'enable-fortran', 'Compile Fortran bindings'
  option 'enable-threadsafe', 'Trade performance and C++ or Fortran support for thread safety'
  option 'enable-parallel', 'Build parallel version'
  option 'force-gcc', 'Forces the install to use gcc'

  def install
    args = %W[]
    if build.include? 'enable-parallel'
        args.concat %W[
          CC=mpicc
          CXX=mpic++
          FC=mpif90
        ]
    elsif build.include? 'force-gcc'
        args.concat %W[
          CC=gcc
          CXX=g++
          FC=gfortran
        ]
    end
    args.concat %W[
      --prefix=#{prefix}
      --enable-production
      --enable-debug=no
      --disable-dependency-tracking
      --with-zlib=/usr
      --with-szlib=#{HOMEBREW_PREFIX}
      --enable-filters=all
      --enable-static=yes
      --enable-shared=yes
    ]

    if build.include? 'enable-threadsafe'
      args.concat %w[--with-pthread=/usr --enable-threadsafe]
    else
      if build.include? 'enable-fortran'
        args << '--enable-fortran'
        ENV.fortran
      end
      if build.include? 'enable-parallel'
        args << '--enable-parallel'
      elsif
        args << '--enable-cxx'
      end
    end


    system './configure', *args
    system "make install"
    end
end
