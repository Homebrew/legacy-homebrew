require 'formula'

class Hdf5 < Formula
  homepage 'http://www.hdfgroup.org/HDF5'
  url 'http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.11.tar.bz2'
  sha1 '87ded0894b104cf23a4b965f4ac0a567f8612e5e'

  # TODO - warn that these options conflict
  option :universal
  option 'enable-fortran', 'Compile Fortran bindings'
  option 'enable-cxx', 'Compile C++ bindings'
  option 'enable-threadsafe', 'Trade performance and C++ or Fortran support for thread safety'
  option 'enable-parallel', 'Compile parallel bindings'
  option 'enable-fortran2003', 'Compile Fortran 2003 bindings. Requires enable-fortran.'

  depends_on :fortran if build.include? 'enable-fortran' or build.include? 'enable-fortran2003'
  depends_on 'szip'
  depends_on :mpi => [:cc, :cxx, :f90] if build.include? "enable-parallel"

  def install
    ENV.universal_binary if build.universal?
    args = %W[
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

    args << '--enable-parallel' if build.include? 'enable-parallel'
    if build.include? 'enable-threadsafe'
      args.concat %w[--with-pthread=/usr --enable-threadsafe]
    else
      if build.include? 'enable-cxx'
        args << '--enable-cxx'
      end
      if build.include? 'enable-fortran' or build.include? 'enable-fortran2003'
        args << '--enable-fortran'
        args << '--enable-fortran2003' if build.include? 'enable-fortran2003'
      end
    end

    if build.include? 'enable-parallel'
      ENV['CC'] = 'mpicc'
      ENV['FC'] = 'mpif90'
    end

    system "./configure", *args
    system "make install"
  end
end
