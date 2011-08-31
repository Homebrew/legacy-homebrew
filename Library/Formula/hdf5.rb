require 'formula'

def fortran?
  ARGV.include? '--enable-fortran'
end

def threadsafe?
  ARGV.include? '--enable-threadsafe'
end

class Hdf5 < Formula
  url 'http://www.hdfgroup.org/ftp/HDF5/hdf5-1.8.7/src/hdf5-1.8.7.tar.bz2'
  homepage 'http://www.hdfgroup.org/HDF5/'
  sha1 'be1daff26f066aca0b5be52d86dada6757fc4b95'

  depends_on 'szip'

  def options
    [
      ['--enable-fortran', 'Compile Fortran bindings at the expense of having shared libraries'],
      ['--enable-threadsafe', 'Trade performance and C++ or Fortran support for thread safety']
    ]
  end

  def install
    ENV.fortran if fortran?

    args = [
      "--prefix=#{prefix}",
      '--disable-debug',
      '--disable-dependency-tracking',
      '--enable-production',
      '--with-zlib=yes',
      '--with-szlib=yes',
      '--enable-filters=all'
    ]
    args.concat ['--with-pthread=/usr', '--enable-threadsafe'] if threadsafe?
    args << '--enable-cxx' unless threadsafe?
    args << '--enable-fortran' if fortran? and not threadsafe?

    system "./configure", *args
    system "make install"
  end
end
