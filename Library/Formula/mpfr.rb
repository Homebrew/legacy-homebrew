require "formula"

class Mpfr < Formula
  homepage "http://www.mpfr.org/"
  # Upstream is down a lot, so use the GNU mirror + Gist for patches
  url "http://ftpmirror.gnu.org/mpfr/mpfr-3.1.2.tar.bz2"
  mirror "http://ftp.gnu.org/gnu/mpfr/mpfr-3.1.2.tar.bz2"
  sha1 "46d5a11a59a4e31f74f73dd70c5d57a59de2d0b4"
  version "3.1.2-p10"

  bottle do
    cellar :any
    sha1 "4612c09b4f5cb156d86f2e404a8b50821729dd34" => :mavericks
    sha1 "f4cdf0f09d9fe0f29742720895f4f4cc84960bb7" => :mountain_lion
    sha1 "606d4d79126cd3eb22e1cfa8cc6479186b07de39" => :lion
  end

  # http://www.mpfr.org/mpfr-current/allpatches
  patch do
    url "https://gist.githubusercontent.com/jacknagel/7f276cd60149a1ffc9a7/raw/39116c674a8c340fef880a393d7c7bdc6d73c59e/mpfr-3.1.2-p10.diff"
    sha1 "c101708c6f7d86a3f7309c2e046d907ac36d6aa4"
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
