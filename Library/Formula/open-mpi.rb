require 'formula'

class OpenMpi <Formula
  url 'http://www.open-mpi.org/software/ompi/v1.4/downloads/openmpi-1.4.2.tar.gz'
  homepage 'www.open-mpi.org'
  md5 'e4f58c7e6792e4549424cb0420eb8655'

  def install
    # Compiler complains about link compatibility with FORTRAN otherwise
    ENV.delete('CFLAGS') 
    ENV.delete('CXXFLAGS')
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
