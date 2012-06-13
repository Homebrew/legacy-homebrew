require 'formula'

class OpenMpi < Formula
  homepage 'http://www.open-mpi.org/'
  url 'http://www.open-mpi.org/software/ompi/v1.6/downloads/openmpi-1.6.tar.bz2'
  sha1 '8b81eea712bb8f8120468003b5f29baecedf2367'

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
