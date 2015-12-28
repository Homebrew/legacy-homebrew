class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.5.1.tar.gz"
  sha256 "779206f2f832987c3d3419e5a194f0b0288fe129ce2b2e264750e9618671f3ce"

  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "7f82a6ecdff222b80f67ce66a4efd96f90c6418c2ae8d02f5f2acbd1db6fd66e" => :el_capitan
    sha256 "4b3ea1e4359b427de864a21450aefb5717e267e0c5351674f839021ca1d22cc6" => :yosemite
    sha256 "5406b8c8a805f20e645e70bdd38141a5a8182ea7aebe137483c6b81706bb34b0" => :mavericks
  end

  depends_on "cmake" => :build

  conflicts_with "mbedtls", :because => "fluent-bit includes mbedtls libraries."

  def install
    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    io = IO.popen("#{bin}/fluent-bit --input stdin --output stdout")
    sleep 1
    Process.kill("SIGINT", io.pid)
    Process.wait(io.pid)
    assert_match(/Fluent-Bit v#{version}/, io.read)
  end
end
