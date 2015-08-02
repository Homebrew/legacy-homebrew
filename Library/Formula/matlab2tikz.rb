require "formula"

class Matlab2tikz < Formula
  desc "Convert MATLAB(R) figures into TikZ/Pgfplots figures"
  homepage "https://github.com/matlab2tikz/matlab2tikz"
  url "https://github.com/matlab2tikz/matlab2tikz/archive/1.0.0.tar.gz"
  sha1 "ed59a4973dca0624b5f0baf8e4d8111867793ae1"

  head "https://github.com/matlab2tikz/matlab2tikz.git"

  def install
    (share/"matlab2tikz").install Dir["src/*"]
  end
end
