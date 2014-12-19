require "formula"

class Slurm < Formula
  homepage "https://github.com/mattthias/slurm"
  url "https://github.com/mattthias/slurm/archive/upstream/0.4.2.tar.gz"
  sha1 "927687980445066a0c12c938321a27bc717bcad9"

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
