require "formula"

class TmuxMemCpuLoad < Formula
  homepage "https://github.com/thewtex/tmux-mem-cpu-load"
  url "https://github.com/thewtex/tmux-mem-cpu-load/archive/v3.1.0.tar.gz"
  sha1 "b243a064a24bf86853ae9ab1daf0fb650a23bd97"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
