require 'formula'

class Gmp < Formula
  homepage 'http://gmplib.org/'
  url 'ftp://ftp.gmplib.org/pub/gmp-5.1.1/gmp-5.1.1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/gmp/gmp-5.1.1.tar.bz2'
  sha1 '21d037f7fb32ae305a2e4157cff0c8caab06fe84'

  option '32-bit'

  def install
    if build.build_32_bit?
      ENV.m32
      ENV.append 'ABI', '32'
    end

    system "./configure", "--prefix=#{prefix}", "--enable-cxx"
    system "make"
    system "make check"
    ENV.deparallelize
    system "make install"
  end
end
