require 'formula'

class Solid < Formula
  url 'http://www.dtecta.com/files/solid-3.5.6.tgz'
  homepage 'http://www.dtecta.com/'
  sha1 'bd0afef7842f826c270cff32fc23994aec0b0d65'

  def options
    [
      [ '--enable-doubles', 'Use internal double precision floats' ],
      [ '--enable-tracer', 'Use rounding error tracer' ]
    ]
  end

  def install
    args = ["--disable-dependency-tracking",
            "--disable-debug",
            "--prefix=#{prefix}",
            "--infodir=#{info}" ]
    args << '--enable-doubles' if ARGV.include? '--enable-doubles'
    args << '--enable-tracer' if ARGV.include? '--enable-tracer'

    system "./configure", *args

    # exclude the examples from compiling!
    # the examples do not compile because the include statements
    # for the GLUT library are not platform independent
    inreplace "Makefile", " examples ", " "

    system "make install"
  end
end
