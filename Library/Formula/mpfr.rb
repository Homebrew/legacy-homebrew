require 'formula'

class Mpfr < Formula
  homepage 'http://www.mpfr.org/'
  url 'http://www.mpfr.org/mpfr-3.1.0/mpfr-3.1.0.tar.bz2'
  md5 '238ae4a15cc3a5049b723daef5d17938'

  depends_on 'gmp'

  def options
    [["--32-bit", "Build 32-bit only."]]
  end

  def patches
    "http://www.mpfr.org/mpfr-3.1.0/allpatches"
  end

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    # Build 32-bit where appropriate, and help configure find 64-bit CPUs
    # Note: This logic should match what the GMP formula does.
    if MacOS.prefer_64_bit? and not ARGV.build_32_bit?
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
