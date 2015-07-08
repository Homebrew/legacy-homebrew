class Hackrf < Formula
  desc "Low cost software radio platform"
  homepage "https://github.com/mossmann/hackrf"
  url "https://github.com/mossmann/hackrf/archive/v2014.08.1.tar.gz"
  sha256 "5ab1641a9af766c476e04bfe2f7cbe3d7edd22c324453c22e58e3f0ef51082eb"

  bottle do
    cellar :any
    sha256 "e6099e40f3fa8c6d2cb9e0026a4356c4a4cfc62882dafd153ceeda97934c851f" => :yosemite
    sha256 "d6778e1cf1aa919ce4e193499485e55cb213af8c3e2293cd5efb75f1bc794aa6" => :mavericks
    sha256 "3827da85010c33469b0ede4898512c20be2edbe932027ba764c6fa0e1e6e6e48" => :mountain_lion
  end

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
