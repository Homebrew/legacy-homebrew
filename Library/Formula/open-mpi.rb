require 'formula'

class OpenMpi < Formula
  homepage 'http://www.open-mpi.org/'
  url 'http://www.open-mpi.org/software/ompi/v1.6/downloads/openmpi-1.6.3.tar.bz2'
  sha1 'a61aa2dee4c47d93d88e49ebed36de25df4f6492'

  # Reported upstream at version 1.6, both issues
  # http://www.open-mpi.org/community/lists/devel/2012/05/11003.php
  # http://www.open-mpi.org/community/lists/devel/2012/08/11362.php
  option 'disable-fortran', 'Do not build the Fortran bindings'
  option 'test', 'Verify the build with make check'

  def install
    args = %W[
      CC=gcc
      CXX=g++
      FC=gfortran
      F77=gfortran
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-ipv6
    ]
    if build.include? 'disable-fortran'
      args << '--disable-mpi-f77' << '--disable-mpi-f90'
    else
      ENV.fortran
    end
    system './configure CC=gcc CXX=g++ FC=gfortran F77=gfortran --prefix=/usr/local/Cellar/open-mpi/1.6.3'
    system 'make -j8'
    system 'make install'

    # If Fortran bindings were built, there will be a stray `.mod` file
    # (Fortran header) in `lib` that needs to be moved to `include`.
    include.install lib/'mpi.mod' if File.exists? "#{lib}/mpi.mod"

    # Not sure why the wrapped script has a jar extension - adamv
    libexec.install bin/'vtsetup.jar'
    bin.write_jar_script libexec/'vtsetup.jar', 'vtsetup.jar'
  end
end
