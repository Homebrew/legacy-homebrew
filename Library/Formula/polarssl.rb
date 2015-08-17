class Polarssl < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://tls.mbed.org/download/mbedtls-2.0.0-gpl.tgz"
  sha256 "149a06621368540b7e1cef1b203c268439c2edbf29e2e9471d8021125df34952"
  head "https://github.com/ARMmbed/mbedtls.git"

  bottle do
    cellar :any
    sha256 "cb5cfc1e0a888aa765b2daf5221f0dbf3be84756104256fe583ad64097dfb5d4" => :yosemite
    sha256 "2382d6afa0fbe0b16c8ee9cdfa3040a429bca50450f9a5449775b741461109f5" => :mavericks
    sha256 "748679c378c9a2d98d880b66ac3bfb507fe79804bb00073084a532bd4d5cb020" => :mountain_lion
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
