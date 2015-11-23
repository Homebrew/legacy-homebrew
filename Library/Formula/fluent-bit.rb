class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.3.tar.gz"
  sha256 "9fe68127597a394ac21f2f1b632d9737fbb7630d9c19fa46cf3f5c7a50a5a226"

  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "1c4a0c46320033977a68d7a35aa550cafdced5b2b20f4294c3d8026a35505003" => :el_capitan
    sha256 "e730625a8a3cc64bec046a082fd9472d5356f5ad0ba19f2f44ad0e19903384a8" => :yosemite
    sha256 "92f46d5be09dc58107fb10f0c1b68a7b96607d6e93b3e4ea236085bed4e83643" => :mavericks
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
