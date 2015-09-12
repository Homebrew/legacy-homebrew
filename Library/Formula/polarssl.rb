class Polarssl < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://tls.mbed.org/download/mbedtls-2.1.0-gpl.tgz"
  sha256 "b61b5fe6aa33ed365289478ac48f1496b97eef0fb813295e534e0c2bd435dcfc"
  head "https://github.com/ARMmbed/mbedtls.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e0c1b86cd38c7c59f0da2e9a7ffbbc775aef79f11d183f3a3315f912b247521" => :yosemite
    sha256 "9733d55faba83d4b18c0ed5760cfe03824577545a9215d098d33f43e70d93d1d" => :mavericks
    sha256 "77c87bc196863df7628258afdb8b0103f71254af9b3d27e3725b31aca0217205" => :mountain_lion
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

    # Why does PolarSSL ship with a "Hello World" executable. Let's remove that.
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
