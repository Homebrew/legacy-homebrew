class Vramsteg < Formula
  desc "Add progress bars to command-line applications"
  homepage "http://tasktools.org/projects/vramsteg.html"
  url "http://taskwarrior.org/download/vramsteg-1.0.1.tar.gz"
  sha256 "bc47e078079a845fa9c9cc5e4c9f4585402430ac6efc82ea6ff607506af8bdb9"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
