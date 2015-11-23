class Gmp < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  url "http://ftpmirror.gnu.org/gmp/gmp-6.0.0a.tar.bz2"
  mirror "https://gmplib.org/download/gmp/gmp-6.0.0a.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/gmp/gmp-6.0.0a.tar.bz2"
  sha256 "7f8e9a804b9c6d07164cf754207be838ece1219425d64e28cfa3e70d5c759aaf"

  bottle do
    cellar :any
    sha256 "616e465ea6c792e41c9870071128a42ad3db0988f678c4a27b9aa4aa60071abb" => :el_capitan
    sha1 "93ad3c1a012806518e9a128d6eb5b565b4a1771d" => :yosemite
    sha1 "bfaab8c533af804d4317730f62164b9c80f84f24" => :mavericks
    sha1 "99dc6539860a9a8d3eb1ac68d5b9434acfb2d846" => :mountain_lion
    sha1 "466b7549553bf0e8f14ab018bd89c48cbd29a379" => :lion
  end

  option "32-bit"
  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    args = ["--prefix=#{prefix}", "--enable-cxx"]

    if build.build_32_bit?
      ENV.m32
      args << "ABI=32"
    end

    # https://github.com/Homebrew/homebrew/issues/20693
    args << "--disable-assembly" if build.build_32_bit? || build.bottle?

    system "./configure", *args
    system "make"
    system "make", "check"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gmp.h>

      int main()
      {
        mpz_t integ;
        mpz_init (integ);
        mpz_clear (integ);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgmp", "-o", "test"
    system "./test"
  end
end
