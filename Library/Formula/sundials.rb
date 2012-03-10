require 'formula'

class Sundials < Formula
  url 'https://computation.llnl.gov/casc/sundials/download/code/sundials-2.4.0.tar.gz'
  homepage 'https://computation.llnl.gov/casc/sundials/main.html'
  md5 '4dbe9b98e66cf7670f42ecb73bf8216e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
