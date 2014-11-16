require "formula"

class Cpanminus < Formula
  homepage "https://github.com/miyagawa/cpanminus"
  url "https://github.com/miyagawa/cpanminus/archive/1.7014.tar.gz"
  sha1 "b82e73a501b9b64d98e2dd4e7ed6b1db801619b8"

  head "https://github.com/miyagawa/cpanminus.git"

  def install
    bin.install "cpanm"
  end
end
