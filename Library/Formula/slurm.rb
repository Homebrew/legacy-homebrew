require "formula"

class Slurm < Formula
  homepage "https://github.com/mattthias/slurm"
  url "https://github.com/mattthias/slurm/archive/upstream/0.4.2.tar.gz"
  sha1 "927687980445066a0c12c938321a27bc717bcad9"

  bottle do
    cellar :any
    sha1 "337859641874b00b07d68193b478b3d24f662f18" => :mavericks
    sha1 "d46703938055e25cf259cb571b89af042328c96c" => :mountain_lion
    sha1 "be55409fce424e606344f9d904423a7f09cd4caa" => :lion
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
