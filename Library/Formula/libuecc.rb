class Libuecc < Formula
  desc "Very small Elliptic Curve Cryptography library"
  homepage "http://git.universe-factory.net/libuecc/"
  url "http://git.universe-factory.net/libuecc/snapshot/libuecc-5.tar"
  sha256 "5f4104e70e48f077f92395e6652d9a139e3fdbcc4dc51113ddc955bf2a82542a"

  head "git://git.universe-factory.net/libuecc"

  bottle do
    cellar :any
    sha256 "704ce2e0e2d517c66d797d4ece988a998a86941e61d1842dd94b0f340a822260" => :el_capitan
    sha256 "a50e505adc4a10c45014aae1252a88fb79121687aa7ccc338c66a169837838a9" => :yosemite
    sha256 "f98e022b1d1c5cf68170eb3958322d34aa736f49a2bfbdacaac8fe277206e27f" => :mavericks
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
