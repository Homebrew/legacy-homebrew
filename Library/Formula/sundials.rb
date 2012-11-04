require 'formula'

class Sundials < Formula
  homepage 'https://computation.llnl.gov/casc/sundials/main.html'
  url 'https://computation.llnl.gov/casc/sundials/download/code/sundials-2.5.0.tar.gz'
  sha1 '9affcc525269e80c8ec6ae1db1e0a0ff201d07e0'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
