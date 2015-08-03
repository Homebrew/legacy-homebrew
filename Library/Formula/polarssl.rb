class Polarssl < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://tls.mbed.org/download/mbedtls-2.0.0-gpl.tgz"
  sha256 "149a06621368540b7e1cef1b203c268439c2edbf29e2e9471d8021125df34952"
  head "https://github.com/ARMmbed/mbedtls.git"

  bottle do
    cellar :any
    revision 1
    sha1 "9f073fda6a57f9ce78768f9391c0c92850d187de" => :yosemite
    sha1 "722cb2387ea35a3c394cb6854068fc124badca09" => :mavericks
    sha1 "4a0effaa65d9fa92a0c6da1914de2dbdd318ecf4" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    # "Comment this macro to disable support for SSL 3.0"
    inreplace "include/mbedtls/config.h" do |s|
      s.gsub! "#define MBEDTLS_SSL_PROTO_SSL3", "//#define POLARSSL_SSL_PROTO_SSL3"
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
