require 'formula'

class Gmp < Formula
  homepage 'http://gmplib.org/'
  url 'ftp://ftp.gmplib.org/pub/gmp-5.1.2/gmp-5.1.2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/gmp/gmp-5.1.2.tar.bz2'
  sha1 '2cb498322b9be4713829d94dee944259c017d615'

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
