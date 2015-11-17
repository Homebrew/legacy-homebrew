class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/0.2.0.tar.gz"
  sha256 "ce3cae01e36d453249b128b6101872978c9cdb15cc54a47777b27e66abe95769"

  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "322c8a2b7ea5cf42a6d5b7e770b8310519f541b8fe22f4ae1ca40a81963f739b" => :el_capitan
    sha256 "0ac92206415b3da97ac1c11c68b952302b59aba4abaa7b90737e5d6de2211102" => :yosemite
    sha256 "39561b29681e1d8f6a390da38d6be4fcc58fdda661ffbfaf319ca03eda53dafb" => :mavericks
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
