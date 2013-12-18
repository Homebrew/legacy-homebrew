require 'formula'

class Mpfr < Formula
  homepage 'http://www.mpfr.org/'
  # Upstream is down a lot, so use the GNU mirror + Gist for patches
  url 'http://ftpmirror.gnu.org/mpfr/mpfr-3.1.2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/mpfr/mpfr-3.1.2.tar.bz2'
  sha1 '46d5a11a59a4e31f74f73dd70c5d57a59de2d0b4'

  bottle do
    cellar :any
    revision 1
    sha1 '99b4ddca907f132e803e8a54a48c9e2ba993b5bb' => :mavericks
    sha1 '1763687dd580ac9bd02f31a8b259a1ad568dd3b6' => :mountain_lion
    sha1 '62c126d1d949cb4d545f44d9c45fe4b0bf276fd4' => :lion
  end

  depends_on 'gmp'

  option '32-bit'

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      clang build 421 segfaults while building in superenv;
      see https://github.com/Homebrew/homebrew/issues/15061
      EOS
  end

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    # Build 32-bit where appropriate, and help configure find 64-bit CPUs
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
