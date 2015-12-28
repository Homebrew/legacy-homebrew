class Vramsteg < Formula
  desc "Add progress bars to command-line applications"
  homepage "https://tasktools.org/projects/vramsteg.html"
  url "https://tasktools.org/download/vramsteg-1.1.0.tar.gz"
  sha256 "9cc82eb195e4673d9ee6151373746bd22513033e96411ffc1d250920801f7037"
  head "https://git.tasktools.org/scm/ut/vramsteg.git", :branch => "1.1.1"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # Check to see if vramsteg can obtain the current time as epoch
    assert_match /^\d+$/, shell_output("#{bin}/vramsteg --now")
  end
end
