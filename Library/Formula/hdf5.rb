require 'formula'

class Hdf5 < Formula
  homepage 'http://www.hdfgroup.org/HDF5'
  url 'http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8.10/src/hdf5-1.8.10.tar.bz2'
  sha1 '867a91b75ee0bbd1f1b13aecd52e883be1507a2c'

  depends_on 'szip'
  depends_on MPIDependency.new(:cc, :cxx, :f77, :f90)

  option 'enable-fortran', 'Compile Fortran bindings'
  option 'enable-threadsafe', 'Thread safety. (incompatible with enable-cxx)'
  option 'enable-parallel', 'Enable parallel hdf5 (incompatible with enable-cxx)'
  option 'enable-cxx', 'Compile C++ bindings (incompatible with enable-parallel and enable-threadsafe)'
  option 'test', 'Verify the build with make check'

  def install
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

    if (build.include? 'enable-threadsafe') && (build.include? 'enable-cxx')
      onoe "Incompatible options selected:",
      "enable-threadsafe is not compatible with enable-cxx."
    end

    if (build.include? 'enable-parallel') && (build.include? 'enable-cxx')
      onoe "Incompatible options selected:",
      "enable-parallel is not compatible with enable-cxx."
    end

    args << '--enable-parallel' if build.include? 'enable-parallel'
    args << '--enable-cxx' if build.include? 'enable-cxx'

    if build.include? 'enable-threadsafe'
      args.concat %w[--with-pthread=/usr --enable-threadsafe]
    end

    if build.include? 'enable-fortran'
      args << '--enable-fortran'
      ENV.fortran
    end

    if build.include? 'enable-parallel'
      ENV['CC'] = "#{HOMEBREW_PREFIX}/bin/mpicc"
      ENV['CXX'] = "#{HOMEBREW_PREFIX}/bin/mpicxx"
      ENV['FC'] = "#{HOMEBREW_PREFIX}/bin/mpif90" if build.include? 'enable-fortran'
      system './configure', *args
    else
      system "./configure", *args
    end

    system 'make check' if build.include? 'test'
    system "make install"
  end
end
