require 'formula'

def threadsafe?
  ARGV.include? '--enable-threadsafe'
end

def fortran?
  ARGV.include? '--enable-fortran' and not threadsafe?
end

class Hdf5 < Formula
  homepage 'http://www.hdfgroup.org/HDF5'
  url 'http://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8.9/src/hdf5-1.8.9.tar.bz2'
  sha1 '7d5e5e8caa5970c65e70a5b4ad6787efe0bf70bb'

  depends_on 'szip'

  def options
    [
      ['--enable-fortran', 'Compile Fortran bindings.'],
      ['--enable-threadsafe', 'Trade performance and C++ or Fortran support for thread safety']
    ]
  end

  def install
    ENV.fortran if fortran?

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
    if threadsafe?
      args.concat %w[--with-pthread=/usr --enable-threadsafe]
    else
      args << '--enable-cxx'
      args << '--enable-fortran' if fortran?
    end

    system "./configure", *args
    system "make install"
  end
end
