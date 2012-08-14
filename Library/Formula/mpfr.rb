require 'formula'

class Mpfr < Formula
  homepage 'http://www.mpfr.org/'
  url 'http://www.mpfr.org/mpfr-3.1.1/mpfr-3.1.1.tar.bz2'
  sha256 '7b66c3f13dc8385f08264c805853f3e1a8eedab8071d582f3e661971c9acd5fd'

  depends_on 'gmp'

  option '32-bit'

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    # Build 32-bit where appropriate, and help configure find 64-bit CPUs
    # Note: This logic should match what the GMP formula does.
    if MacOS.prefer_64_bit? and not build.build_32_bit?
      ENV.m64
      args << "--build=x86_64-apple-darwin"
    else
      ENV.m32
      args << "--build=none-apple-darwin"
    end

    system "./configure", *args
    system "make"
    system "make check"
    system "make install"
  end
end
