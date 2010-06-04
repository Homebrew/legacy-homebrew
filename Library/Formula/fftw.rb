require 'formula'

class Fftw <Formula
  @homepage='http://www.fftw.org'
  @url='http://www.fftw.org/fftw-3.2.2.tar.gz'
  @md5='b616e5c91218cc778b5aa735fefb61ae'

  def install
    # single precision
    # enable-sse only works with single
    system "./configure", "--enable-shared",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-threads",
                          "--enable-single",
                          "--enable-sse",
                          "--disable-dependency-tracking",
                          "--disable-fortran"
    system "make install"

    # clean up so we can compile the double precision variant
    system "make clean"

    # double precision
    # enable-sse2 only works with double precision (default)
    system "./configure", "--enable-shared",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-threads",
                          "--enable-sse2",
                          "--disable-dependency-tracking",
                          "--disable-fortran"

    system "make install"

    # clean up so we can compile the long-double precision variant
    system "make clean"

    # long-double precision
    # no SIMD optimization available 
    system "./configure", "--enable-shared",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-threads",
                          "--enable-long-double",
                          "--disable-dependency-tracking",
                          "--disable-fortran"

    system "make install"

    #wtf file?
    (prefix+'share/info/dir').unlink
  end
end
