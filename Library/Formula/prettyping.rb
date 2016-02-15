class Prettyping < Formula
  desc "Wrapper to colorize and simplify ping's output"
  homepage "https://denilsonsa.github.io/prettyping/"
  url "https://github.com/denilsonsa/prettyping/archive/v1.0.0.tar.gz"
  sha256 "02a4144ff2ab7d3e2c7915041225270e96b04ee97777be905d1146e76084805d"

  bottle :unneeded

  def install
    bin.install "prettyping"
  end

  test do
    system "#{bin}/prettyping", "-c", "3", "127.0.0.1"
  end
end
