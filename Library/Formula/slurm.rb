class Slurm < Formula
  desc "Yet another network load monitor"
  homepage "https://github.com/mattthias/slurm"
  url "https://github.com/mattthias/slurm/archive/upstream/0.4.2.tar.gz"
  sha256 "8a28e11650928d87a907f9b154f6efd1ad5854cdc56a528da2e02e756e0aa58e"

  bottle do
    cellar :any
    sha256 "10c38d17815ce54307d66dca10ba4941cb177e5cc28a12b242bd89c922146b0c" => :yosemite
    sha256 "3c1ca846a173a24f4cb5ac82cef839d751087997cf306f6a0a7c697d9fe3dbd4" => :mavericks
    sha256 "d49d123d14395a089923427c6dfaad3048a7cd277c88a704584e9c3f22d3c783" => :mountain_lion
  end

  depends_on "scons" => :build

  def install
    scons
    bin.install "slurm"
  end

  test do
    system "#{bin}/slurm", "-h"
  end
end
