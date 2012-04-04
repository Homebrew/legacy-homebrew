require 'formula'

class OpenMpi < Formula
  homepage 'http://www.open-mpi.org/'
  url 'http://www.open-mpi.org/software/ompi/v1.4/downloads/openmpi-1.4.5.tar.gz'
  md5 '28b2a7f9c2fcee0217facf47bf35d5ea'

  def install
    # Compiler complains about link compatibility with FORTRAN otherwise
    ENV.delete('CFLAGS')
    ENV.delete('CXXFLAGS')
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"

    # If Fortran bindings were built, there will be a stra `.mod` file (Fortran
    # header) in `lib` that needs to be moved to `include`.
    mv lib + 'mpi.mod', include if (lib + 'mpi.mod').exist?
  end
end
