class TmuxMemCpuLoad < Formula
  homepage "https://github.com/thewtex/tmux-mem-cpu-load"
  url "https://github.com/thewtex/tmux-mem-cpu-load/archive/v3.2.2.tar.gz"
  sha256 "cf595916ccf92ece9d3bc50c71d6963f83515605ad7639407e7f893203ae5022"

  head "https://github.com/thewtex/tmux-mem-cpu-load.git"

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

  test do
    system bin/"tmux-mem-cpu-load"
  end
end
