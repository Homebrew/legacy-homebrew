class Gmp < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  url "https://gmplib.org/download/gmp/gmp-6.1.0.tar.xz"
  sha256 "68dadacce515b0f8a54f510edf07c1b636492bcdb8e8d54c56eb216225d16989"

  bottle do
    cellar :any
    sha256 "616e465ea6c792e41c9870071128a42ad3db0988f678c4a27b9aa4aa60071abb" => :el_capitan
    sha256 "4285afb54989e55e1655788903ef8d9e7702c025cc816663cf66e8223d2c09b4" => :yosemite
    sha256 "7b90ebb78813c9e1a5c38b0b89488f57fcc137851164a80809df76df8c908f36" => :mavericks
    sha256 "a09200da6ca2df703aef5984be92c0aa7548db83174ad977c6c9c3c4eb70ba70" => :mountain_lion
    sha256 "45eede0986bfc5f5dfc09824c2ab1ccc39c3c85a50311adcaf4148eafc632a6c" => :lion
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
