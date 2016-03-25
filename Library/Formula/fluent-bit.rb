class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.6.0.tar.gz"
  sha256 "0de74eebeb629b12ce342b671f12558a6339579887c7b8c87634be4d99ac8d52"

  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "a0c0cc54dab665bca9b16c816c94699aa68a25d3c1a8783de4bde059137cf32a" => :el_capitan
    sha256 "c39c6ef2586f864b30d11948781dc21f3f6922e0346cff5efaae77d62213404a" => :yosemite
    sha256 "a2fc6f2d797b1d773ee32a410a6c40b752783ac6c280af583455e0ddd54e4982" => :mavericks
  end

  depends_on "cmake" => :build

  conflicts_with "mbedtls", :because => "fluent-bit includes mbedtls libraries."

  def install
    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    io = IO.popen("#{bin}/fluent-bit --input stdin --output stdout --daemon")
    sleep 1
    Process.kill("SIGINT", io.pid)
    Process.wait(io.pid)
    assert_match(/Fluent-Bit v#{version}/, io.read)
  end
end
