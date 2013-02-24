require 'formula'

class Bact < Formula
  homepage 'http://chasen.org/~taku/software/bact/'
  url 'http://chasen.org/~taku/software/bact/bact-0.13.tar.gz'
  sha1 'cdc8815e9258868699d98449598058011e993218'

  def install
    system "make"
    system "make test"
    bin.install "bact_learn", "bact_classify","bact_mkmodel"
  end
end
