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
    sha1 "ae9062f1736202e1e6324dbb74f6074d672708e8" => :mavericks
    sha1 "6f4e0967728cb9ff5fad9de53dc38eb1648eee8e" => :mountain_lion
    sha1 "63efa4c854ede1a352d73756d242514e042c8e2e" => :lion
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
