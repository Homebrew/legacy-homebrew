require "formula"

class Cpanminus < Formula
  homepage "https://github.com/miyagawa/cpanminus"
  url "https://github.com/miyagawa/cpanminus/archive/1.7004.tar.gz"
  sha1 "2430c8e8249446de29addc64409cdd9b9408c929"

  head "https://github.com/miyagawa/cpanminus.git"

  def install
    bin.install "cpanm"
  end
end
