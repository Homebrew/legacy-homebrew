require 'formula'

class OpenMpi <Formula
  url 'http://www.open-mpi.org/software/ompi/v1.4/downloads/openmpi-1.4.1.tar.gz'
  homepage 'www.open-mpi.org'
  md5 'a6f87bf31b20206a9ccd4a76608f89d4'

  def install
    # Compiler complains about link compatibility with FORTRAN otherwise
    ENV.delete('CFLAGS') 
    ENV.delete('CXXFLAGS')
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
