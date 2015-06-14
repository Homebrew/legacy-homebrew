class Mpfr < Formula
  desc "C library for multiple-precision floating-point computations"
  homepage "http://www.mpfr.org/"
  # Upstream is down a lot, so use the GNU mirror + Gist for patches
  url "http://ftpmirror.gnu.org/mpfr/mpfr-3.1.2.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/mpfr/mpfr-3.1.2.tar.bz2"
  sha256 "79c73f60af010a30a5c27a955a1d2d01ba095b72537dab0ecaad57f5a7bb1b6b"
  version "3.1.2-p11"

  bottle do
    cellar :any
    sha256 "dc5b8f01cc8e64e4050a922cd0d56fef9b0910a74f9fa99e13e0204664ef3f4f" => :yosemite
    sha256 "02c70285a49d5494c7767ba8f40f7a4a64b236c6e602bedc4a0f42380909baef" => :mavericks
    sha256 "d3ba1d384e725ab12ba23f51e7b8fdbf3a1cd585aff0c74f75e7c07aaa730d58" => :mountain_lion
  end

  # http://www.mpfr.org/mpfr-current/allpatches
  patch do
    url "https://gist.githubusercontent.com/jacknagel/7f276cd60149a1ffc9a7/raw/98bd4a4d77d57d91d501e66af2237dfa41b12719/mpfr-3.1.2-p11.diff"
    sha256 "ef758e28d988180ce4e91860a890bab74a5ef2a0cd57b1174c59a6e81d4f5c64"
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
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gmp.h>
      #include <mpfr.h>

      int main()
      {
        mpfr_t x;
        mpfr_init(x);
        mpfr_clear(x);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lgmp", "-lmpfr", "-o", "test"
    system "./test"
  end
end
