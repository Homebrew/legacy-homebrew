class Slurm < Formula
  desc "Yet another network load monitor"
  homepage "https://github.com/mattthias/slurm"
  url "https://github.com/mattthias/slurm/archive/upstream/0.4.2.tar.gz"
  sha256 "8a28e11650928d87a907f9b154f6efd1ad5854cdc56a528da2e02e756e0aa58e"

  bottle do
    cellar :any
    sha1 "c9e5146835a53aa70ca39ddce836976ae00b699c" => :yosemite
    sha1 "a1b0d39c0203866ae73fece06fae6fddd60e3531" => :mavericks
    sha1 "7ca32c2322a9ffa967c28a13a2d386628129c6d2" => :mountain_lion
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
