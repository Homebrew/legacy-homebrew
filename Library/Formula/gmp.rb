class Gmp < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  url "https://gmplib.org/download/gmp/gmp-6.1.0.tar.xz"
  sha256 "68dadacce515b0f8a54f510edf07c1b636492bcdb8e8d54c56eb216225d16989"

  bottle do
    cellar :any
    sha256 "1d236d4debd6880259e58a51a28f0c2d67fc57c4882f9a690ebc222c8264605b" => :el_capitan
    sha256 "f86f185327ee1f6dc44c816229f332eb262616a648afd5d1caf55c407e72035d" => :yosemite
    sha256 "2ad0982b8c33432ad9c71b0e5517171aee5bc73d2207d7bda3c306e0cf42dcc1" => :mavericks
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
