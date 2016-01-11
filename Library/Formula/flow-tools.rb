class FlowTools < Formula
  desc "Collect, send, process, and generate NetFlow data reports"
  homepage "https://code.google.com/p/flow-tools/"
  url "https://flow-tools.googlecode.com/files/flow-tools-0.68.5.1.tar.bz2"
  sha256 "80bbd3791b59198f0d20184761d96ba500386b0a71ea613c214a50aa017a1f67"

  bottle do
    sha256 "0d3814f50d6bc8d06c808176bc0b6f725f429b231a21eabe49fadf6729a7d27b" => :yosemite
    sha256 "dc15779397a7f60c67b20c314b4513133c0883a5eafb3e972e744b8a70ca1060" => :mavericks
    sha256 "9a101e543b0fc763624f15bf373e60908645dab3ba2360e477eae403cd578e0a" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Generate test flow data with 1000 flows
    data = shell_output("#{bin}/flow-gen")
    # Test that the test flows work with some flow- programs
    pipe_output("#{bin}/flow-cat", data, 0)
    pipe_output("#{bin}/flow-print", data, 0)
    pipe_output("#{bin}/flow-stat", data, 0)
  end
end
