class Mpfr < Formula
  desc "C library for multiple-precision floating-point computations"
  homepage "http://www.mpfr.org/"
  # Upstream is down a lot, so use mirrors
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mpfr4/mpfr4_3.1.3.orig.tar.xz"
  mirror "https://ftp.gnu.org/gnu/mpfr/mpfr-3.1.3.tar.xz"
  sha256 "6835a08bd992c8257641791e9a6a2b35b02336c8de26d0a8577953747e514a16"

  bottle do
    cellar :any
    sha256 "a5028a476fb01f6f5ee89d635e2cf926c233d6620f036fcfeda2fd963cac369a" => :el_capitan
    sha256 "5047806085670ca9f39de8e9afdec2ab82eddb7d1d3154208262f844b43b4dcd" => :yosemite
    sha256 "f1c281e854533cf7fab36396591516d48a61626096f152ea828eaae9f7c09238" => :mavericks
    sha256 "5a98a6a8dd768c845602cabb31db527a0efecdbae3eaa1148db8010ae5420a97" => :mountain_lion
  end

  # http://www.mpfr.org/mpfr-current/allpatches
  patch do
    url "https://gist.github.com/anonymous/3a7d24cf2c68f21eb940/raw/471e928fcdbfb5c2fa7428cfb496496e6ee469aa/mpfr-3.1.3.diff"
    sha256 "1ca002acc121413b9ce39e9f12bb6efe4bed4ec45cf3f3ffcff122b94f6694de"
  end

  option "32-bit"

  depends_on "gmp"

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
