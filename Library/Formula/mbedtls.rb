class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://tls.mbed.org/download/mbedtls-2.2.1-apache.tgz"
  sha256 "6ddd5ca2e7dfb43d2fd750400856246fc1c98344dabf01b1594eb2f9880ef7ce"
  head "https://github.com/ARMmbed/mbedtls.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "81b90377606e7ee223c8af917c0f8f2b2c33fc106d2e6fd9d4ad1364810b2f1c" => :el_capitan
    sha256 "3d8710165e97691dbe2476612693add5fab0209b6fb348c25116f44e0fde3b51" => :yosemite
    sha256 "fbdf96f335faaf9a261ed9edd5bc361c8fc9079894f62c78a6d605091d6a7085" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    # "Comment this macro to disable support for SSL 3.0"
    inreplace "include/mbedtls/config.h" do |s|
      s.gsub! "#define MBEDTLS_SSL_PROTO_SSL3", "//#define MBEDTLS_SSL_PROTO_SSL3"
    end

    system "cmake", *std_cmake_args
    system "make"
    system "make", "install"

    # Why does Mbedtls ship with a "Hello World" executable. Let's remove that.
    rm_f "#{bin}/hello"
    # Rename benchmark & selftest, which are awfully generic names.
    mv bin/"benchmark", bin/"mbedtls-benchmark"
    mv bin/"selftest", bin/"mbedtls-selftest"
    # Demonstration files shouldn't be in the main bin
    libexec.install "#{bin}/mpi_demo"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    # Don't remove the space between the checksum and filename. It will break.
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249  testfile.txt"
    assert_equal expected_checksum, shell_output("#{bin}/generic_sum SHA256 testfile.txt").strip
  end
end
