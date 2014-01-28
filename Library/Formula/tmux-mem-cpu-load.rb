require 'formula'

class TmuxMemCpuLoad < Formula
  homepage 'https://github.com/thewtex/tmux-mem-cpu-load'
  url 'https://github.com/thewtex/tmux-mem-cpu-load/archive/v2.2.1.tar.gz'
  sha1 'fc406fe40b0abf2abb56cad57ad8e2e3a25dae54'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
