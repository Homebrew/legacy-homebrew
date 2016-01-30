class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.6.0.tar.gz"
  sha256 "0de74eebeb629b12ce342b671f12558a6339579887c7b8c87634be4d99ac8d52"

  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "41dab8f88e949c09facec8d48372e8769cfc93aa71eafa53d5c57ebf4703c4ad" => :el_capitan
    sha256 "0bd6b89f0257a207148b52fc706ee911bcf3462df08e85d36298d3cfd5330977" => :yosemite
    sha256 "e454dde4f57ca45c6a22e0458ecf456c8b83beca1a5090f5ef2326a8b2cce259" => :mavericks
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
