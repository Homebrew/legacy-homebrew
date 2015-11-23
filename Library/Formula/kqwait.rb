class Kqwait < Formula
  desc "Wait for events on files or directories on OS X"
  homepage "https://github.com/sschober/kqwait"
  url "https://github.com/sschober/kqwait/archive/kqwait-v1.0.3.tar.gz"
  sha256 "878560936d473f203c0ccb3d42eadccfb50cff15e6f15a59061e73704474c531"

  head "https://github.com/sschober/kqwait.git"

  def install
    system "make"
    bin.install "kqwait"
  end

  test do
    system "#{bin}/kqwait", "-v"
  end
end
