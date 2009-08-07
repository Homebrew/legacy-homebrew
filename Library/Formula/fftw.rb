require 'brewkit'

class Fftw <Formula
  @homepage='http://www.fftw.org'
  @url='http://www.fftw.org/fftw-3.2.1.tar.gz'
  @md5='712d3f33625a0a76f5758648d4b925f7'

  def install
    system "./configure", "--enable-shared",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-threads",
                          "--enable-single",
                          "--enable-sse",
                          "--disable-dependency-tracking",
                          "--disable-fortran"
    system "make install"

    #wtf file?
    (prefix+'share'+'info'+'dir').unlink
  end
end