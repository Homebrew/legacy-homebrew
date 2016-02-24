class Pbzip2 < Formula
  desc "Parallel bzip2"
  homepage "http://compression.ca/pbzip2/"
  url "https://launchpad.net/pbzip2/1.1/1.1.12/+download/pbzip2-1.1.12.tar.gz"
  sha256 "573bb358a5a7d3bf5f42f881af324cedf960c786e8d66dd03d448ddd8a0166ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "baaa2981ded1c6a0731bed32fbb22b3e143612fadd8452b79c78732f9ac1a903" => :el_capitan
    sha256 "0fb0998fb35b62add5348bbf1c50372220052d52347be7b11e949e27b3997e1c" => :yosemite
    sha256 "ac0e6128b16cb551a926fb713d8a4154e29ada2b71f231ecee2ebdab4d4bea96" => :mavericks
    sha256 "7604662202fbb60acdb016da163b552b1c2cee6a4bdd21ca2be85afb1ce4c987" => :mountain_lion
  end

  fails_with :llvm do
    build 2334
  end

  def install
    system "make", "PREFIX=#{prefix}",
                   "CC=#{ENV.cxx}",
                   "CFLAGS=#{ENV.cflags}",
                   "PREFIX=#{prefix}",
                   "install"
  end
end
