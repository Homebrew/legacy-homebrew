class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/0.1.0.tar.gz"
  sha256 "5d77c75b1261695ca7f7b4752f5563b80c63c9d68f89fa6f5a1bfcd197a2a785"

  head "https://github.com/fluent/fluent-bit.git"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    io = IO.popen("#{bin}/fluent-bit --input stdin --output stdout")
    sleep 5
    Process.kill("SIGINT", io.pid)
    Process.wait(io.pid)
    io.read =~ /Fluent-Bit v#{version}/
  end
end
