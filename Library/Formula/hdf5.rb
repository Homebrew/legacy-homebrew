require 'formula'

class Hdf5 < Formula
  homepage 'http://www.hdfgroup.org/HDF5'
  url 'http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8.9/src/hdf5-1.8.9.tar.bz2'
  sha1 '7d5e5e8caa5970c65e70a5b4ad6787efe0bf70bb'

  depends_on 'szip'

  # TODO - warn that these options conflict
  option :universal
  option 'enable-fortran', 'Compile Fortran bindings'
  option 'enable-cxx', 'Compile C++ bindings'
  option 'enable-threadsafe', 'Trade performance and C++ or Fortran support for thread safety'
  option 'enable-parallel', 'Compile parallel bindings'

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

    if build.include? 'enable-parallel'
      args << '--enable-parallel'
    end
    if build.include? 'enable-threadsafe'
      args.concat %w[--with-pthread=/usr --enable-threadsafe]
    else
      if build.include? 'enable-cxx'
        args << '--enable-cxx'
      end
      if build.include? 'enable-fortran'
        args << '--enable-fortran'
        ENV.fortran
      end
    end

    if build.include? 'enable-parallel'
      ENV['CC'] = 'mpicc'
      ENV['FC'] = 'mpif90'
      system './configure', *args
    else
      system "./configure", *args
    end
    system "make install"
  end
end
