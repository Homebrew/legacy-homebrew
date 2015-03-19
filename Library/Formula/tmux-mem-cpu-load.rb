require "formula"

class TmuxMemCpuLoad < Formula
  homepage "https://github.com/thewtex/tmux-mem-cpu-load"
  url "https://github.com/thewtex/tmux-mem-cpu-load/archive/v3.1.0.tar.gz"
  sha1 "b243a064a24bf86853ae9ab1daf0fb650a23bd97"

  bottle do
    cellar :any
    sha1 "f1128ff9697f59c56caa8f83d09752749fa2937d" => :yosemite
    sha1 "9b8093ea6d70b3665594fa166e8067c4bd0576fa" => :mavericks
    sha1 "93df136a1c19a26bb236b4b99e6a96b39014bf17" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
