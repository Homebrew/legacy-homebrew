class Vramsteg < Formula
  desc "Add progress bars to command-line applications"
  homepage "https://tasktools.org/projects/vramsteg.html"
  url "https://tasktools.org/download/vramsteg-1.1.0.tar.gz"
  sha256 "9cc82eb195e4673d9ee6151373746bd22513033e96411ffc1d250920801f7037"
  head "https://git.tasktools.org/scm/ut/vramsteg.git", :branch => "1.1.1"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4b3e2e66c2f772a38de529b884091a2ffa1f920af6604696129d21cc9e70b99" => :el_capitan
    sha256 "9285766e0502b88c62d3d295402a41c46b8d9d2707a492bb5d70484b1080c212" => :yosemite
    sha256 "f9ea5a2984d676db153d2128b1aa84a413edb93692e9c6be8147e5a856d42972" => :mavericks
  end

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
