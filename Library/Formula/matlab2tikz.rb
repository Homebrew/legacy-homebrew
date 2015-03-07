require "formula"

class Matlab2tikz < Formula
  homepage "https://github.com/nschloe/matlab2tikz"
  url "https://github.com/nschloe/matlab2tikz/archive/0.5.0.tar.gz"
  sha1 "1c53d378be87fc9ca43c921ab7193257ea416864"

  head "https://github.com/nschloe/matlab2tikz.git"

  def install
    (share/"matlab2tikz").install Dir["src/*"]
  end
end
