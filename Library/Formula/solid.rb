require 'formula'

class Solid < Formula
  homepage 'http://www.dtecta.com/'
  url 'http://www.dtecta.com/files/solid-3.5.6.tgz'
  sha1 'bd0afef7842f826c270cff32fc23994aec0b0d65'

  option 'enable-doubles', 'Use internal double precision floats'
  option 'enable-tracer', 'Use rounding error tracer'

  def install
    args = ["--disable-dependency-tracking",
            "--disable-debug",
            "--prefix=#{prefix}",
            "--infodir=#{info}" ]
    args << '--enable-doubles' if build.include? 'enable-doubles'
    args << '--enable-tracer' if build.include? 'enable-tracer'

    system "./configure", *args

    # exclude the examples from compiling!
    # the examples do not compile because the include statements
    # for the GLUT library are not platform independent
    inreplace "Makefile", " examples ", " "

    system "make install"
  end
end
