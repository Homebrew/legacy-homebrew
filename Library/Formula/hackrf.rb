class Hackrf < Formula
  homepage "https://github.com/mossmann/hackrf"
  url "https://github.com/mossmann/hackrf/archive/v2014.08.1.tar.gz"
  sha256 "5ab1641a9af766c476e04bfe2f7cbe3d7edd22c324453c22e58e3f0ef51082eb"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    cd "host" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    shell_output("hackrf_transfer", 1)
  end
end
