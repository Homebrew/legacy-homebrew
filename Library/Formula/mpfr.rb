require 'formula'

class Mpfr < Formula
  homepage 'http://www.mpfr.org/'
  # Upstream is down a lot, so use the GNU mirror + Gist for patches
  url 'http://ftpmirror.gnu.org/mpfr/mpfr-3.1.2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/mpfr/mpfr-3.1.2.tar.bz2'
  sha1 '46d5a11a59a4e31f74f73dd70c5d57a59de2d0b4'

  depends_on 'gmp'

  option '32-bit'

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      clang build 421 segfaults while building in superenv;
      see https://github.com/mxcl/homebrew/issues/15061
      EOS
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
