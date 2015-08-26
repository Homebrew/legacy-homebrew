class Matlab2tikz < Formula
  desc "Convert MATLAB(R) figures into TikZ/Pgfplots figures"
  homepage "https://github.com/matlab2tikz/matlab2tikz"
  url "https://github.com/matlab2tikz/matlab2tikz/archive/1.0.0.tar.gz"
  sha256 "16d212f333afa100f2ec307c85957532ceb8163aebc7021770dfc68f6f2f8f1a"

  head "https://github.com/matlab2tikz/matlab2tikz.git"

  def install
    (share/"matlab2tikz").install Dir["src/*"]
  end
end
