require "formula"

class Cpanminus < Formula
  homepage "https://github.com/miyagawa/cpanminus"
  url "https://github.com/miyagawa/cpanminus/archive/1.7011.tar.gz"
  sha1 "1b81b0b5927b8ce2581c82a0f9c71eed62160e78"

  head "https://github.com/miyagawa/cpanminus.git"

  def install
    bin.install "cpanm"
  end
end
