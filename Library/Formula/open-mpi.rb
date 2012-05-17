require 'formula'

class OpenMpi < Formula
  homepage 'http://www.open-mpi.org/'
  url 'http://www.open-mpi.org/software/ompi/v1.6/downloads/openmpi-1.6.tar.bz2'
  sha1 '8b81eea712bb8f8120468003b5f29baecedf2367'

  # Reported upstream at version 1.6 here:
  # http://www.open-mpi.org/community/lists/devel/2012/05/11003.php
  fails_with :clang do
    build 318
    cause 'fails make check'
  end

  def options
    [
      ['--disable-fortran', 'Do not build the Fortran bindings'],
      ['--test', 'Verify the build with make check']
    ]
  end

  def install
    # Compiler complains about link compatibility with FORTRAN otherwise
    ENV.delete('CFLAGS')
    ENV.delete('CXXFLAGS')
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-ipv6
    ]
    if ARGV.include? '--disable-fortran'
      args << '--disable-mpi-f77' << '--disable-mpi-f90'
    else
      ENV.fortran
    end
    system './configure', *args
    system 'make all'
    system 'make check' if ARGV.include? '--test'
    system 'make install'
    # If Fortran bindings were built, there will be a stra `.mod` file (Fortran
    # header) in `lib` that needs to be moved to `include`.
    mv "#{lib}/mpi.mod", include if File.exists? "#{lib}/mpi.mod"
    mv "#{bin}/vtsetup.jar", libexec
    (bin+'vtsetup.jar').write <<-EOS.undent
      #!/bin/bash
      java -jar "#{libexec}/vtsetup.jar" "$@"
    EOS
  end
end
