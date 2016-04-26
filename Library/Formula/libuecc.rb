class Libuecc < Formula
  desc "Very small Elliptic Curve Cryptography library"
  homepage "https://git.universe-factory.net/libuecc/"
  url "https://git.universe-factory.net/libuecc/snapshot/libuecc-6.tar"
  sha256 "fe61715b7cd8458616840f71ab8c0c7e5f49480a9cfb2c1965fbb9d713f071b6"

  head "https://git.universe-factory.net/libuecc"

  bottle do
    cellar :any
    revision 1
    sha256 "ed13876ca85617cfe1f6fd174ebd4502d29096d2b8c4bcaf3facc9749f28ae34" => :el_capitan
    sha256 "eb7bcbd632f8f5f1faedbbe49529a9b1820d31530b5a256558d4e99edc2953e1" => :yosemite
    sha256 "dfdb783678a0aa3a8edd745d890921b8213f3e1075d152a13a207053e178e270" => :mavericks
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
