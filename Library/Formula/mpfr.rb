require "formula"

class Mpfr < Formula
  homepage "http://www.mpfr.org/"
  # Upstream is down a lot, so use the GNU mirror + Gist for patches
  url "http://ftpmirror.gnu.org/mpfr/mpfr-3.1.2.tar.bz2"
  mirror "http://ftp.gnu.org/gnu/mpfr/mpfr-3.1.2.tar.bz2"
  sha1 "46d5a11a59a4e31f74f73dd70c5d57a59de2d0b4"
  version "3.1.2-p8"

  bottle do
    cellar :any
    revision 1
    sha1 '99b4ddca907f132e803e8a54a48c9e2ba993b5bb' => :mavericks
    sha1 '1763687dd580ac9bd02f31a8b259a1ad568dd3b6' => :mountain_lion
    sha1 '62c126d1d949cb4d545f44d9c45fe4b0bf276fd4' => :lion
  end

  # http://www.mpfr.org/mpfr-current/allpatches
  patch do
    url "https://gist.githubusercontent.com/jacknagel/7f276cd60149a1ffc9a7/raw/0f2c24423ceda0dae996e2333f395c7115db33ec/mpfr-3.1.2-8.diff"
    sha1 "047c96dcfb86f010972dedae088a3e67eaaecb8a"
  end

  depends_on "gmp"

  option "32-bit"

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      clang build 421 segfaults while building in superenv;
      see https://github.com/Homebrew/homebrew/issues/15061
      EOS
  end

  def install
    ENV.m32 if build.build_32_bit?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end
end
