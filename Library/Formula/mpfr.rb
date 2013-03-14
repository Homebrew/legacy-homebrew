require 'formula'

class Mpfr < Formula
  homepage 'http://www.mpfr.org/'
  # Upstream is down a lot, so use the GNU mirror + Gist for patches
  url 'http://ftpmirror.gnu.org/mpfr/mpfr-3.1.1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/mpfr/mpfr-3.1.1.tar.bz2'
  version '3.1.1-p2'
  sha1 'f632d43943ff9f13c184fa13b9a6e8c7f420f4dd'

  depends_on 'gmp'

  option '32-bit'

  # Segfaults under superenv with clang 4.1/421. See:
  # https://github.com/mxcl/homebrew/issues/15061
  env :std

  def patches
    "https://gist.github.com/raw/4472199/42c0b207037a133527083d12adc9028b4da429ee/gistfile1.txt"
  end

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
