require 'formula'

def fortran?
  ARGV.include? '--enable-fortran'
end

def threadsafe?
  ARGV.include? '--enable-threadsafe'
end

class Hdf5 < Formula
  url 'http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.6.tar.bz2'
  homepage 'http://www.hdfgroup.org/HDF5/'
  sha1 '348bd881c03a9568ac4ea9071833d6119c733757'
  version '1.8.6'

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
