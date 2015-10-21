class Libuecc < Formula
  desc "Very small Elliptic Curve Cryptography library"
  homepage "http://git.universe-factory.net/libuecc/"
  url "http://git.universe-factory.net/libuecc/snapshot/libuecc-5.tar"
  sha256 "5f4104e70e48f077f92395e6652d9a139e3fdbcc4dc51113ddc955bf2a82542a"

  head "git://git.universe-factory.net/libuecc"

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
