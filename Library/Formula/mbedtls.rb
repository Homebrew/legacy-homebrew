class Mbedtls < Formula
  desc "Cryptographic & SSL/TLS library"
  homepage "https://tls.mbed.org/"
  url "https://tls.mbed.org/download/mbedtls-2.2.0-apache.tgz"
  sha256 "3c6d3487ab056da94450cf907afc84f026aff7880182baffe137c98e3d00fb55"
  head "https://github.com/ARMmbed/mbedtls.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "deaf1fbfeb8b53d1b9438cee02d7a8231356f37cdb5ef0b2f57e39c9fff0e65e" => :el_capitan
    sha256 "2eb2f138b0650f92709264eb8601756b9f64f852f428454dea3051feca271877" => :yosemite
    sha256 "1deb8eecc649326f45658b8ff884cfa022d21853b9b699d91920de35819a24a2" => :mavericks
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
