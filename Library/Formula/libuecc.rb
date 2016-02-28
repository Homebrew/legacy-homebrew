class Libuecc < Formula
  desc "Very small Elliptic Curve Cryptography library"
  homepage "https://git.universe-factory.net/libuecc/"
  url "https://git.universe-factory.net/libuecc/snapshot/libuecc-6.tar"
  sha256 "fe61715b7cd8458616840f71ab8c0c7e5f49480a9cfb2c1965fbb9d713f071b6"

  head "https://git.universe-factory.net/libuecc"

  bottle do
    cellar :any
    sha256 "f2f8b73e024086946b28531462bf6fdb7d53d555c49ff2b19d046c6ae4397abe" => :el_capitan
    sha256 "ae65696aaa43faefb426eccdd60bed6bcd9e267f6bb4cde7eccb8f5846126601" => :yosemite
    sha256 "5013357b9cc252f75220bff31182e618eda02468bb7ccabb6d9c9de503ef2e1f" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdlib.h>
      #include <libuecc/ecc.h>

      int main(void)
      {
          ecc_int256_t secret;
          ecc_25519_gf_sanitize_secret(&secret, &secret);

          return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "-I#{include}/libuecc-#{version}", "-L#{lib}", "-o", "test", "test.c", "-luecc"
    system "./test"
  end
end
