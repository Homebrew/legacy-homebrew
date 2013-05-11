require 'formula'

class Gmp < Formula
  homepage 'http://gmplib.org/'
  url 'ftp://ftp.gmplib.org/pub/gmp-5.1.1/gmp-5.1.1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/gmp/gmp-5.1.1.tar.bz2'
  sha1 '21d037f7fb32ae305a2e4157cff0c8caab06fe84'

  bottle do
    cellar :any
    sha1 'f405e9d565890441dbccd62955a0bd168f98b86d' => :mountain_lion
    sha1 '80a8c65afd5cea11c96b63226414a03890748051' => :lion
    sha1 'e6fe1b5e9a74b3ad3979701a9b449838692b7cab' => :snow_leopard
  end

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
