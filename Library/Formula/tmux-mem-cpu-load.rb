require "formula"

class TmuxMemCpuLoad < Formula
  homepage "https://github.com/thewtex/tmux-mem-cpu-load"
  url "https://github.com/thewtex/tmux-mem-cpu-load/archive/v2.2.2.tar.gz"
  sha1 "5c49317b072dec710268d3dafb205b4aeb0c1a5c"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
