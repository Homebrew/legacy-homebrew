require "formula"

class BoostBuild < Formula
  homepage "http://boost.org/boost-build2/"
  url "https://github.com/boostorg/build/archive/2014.10.tar.gz"
  sha1 "64f59424b829e9b5741bda58c78d830c993a0042"

  head "https://github.com/boostorg/build.git"

  bottle do
    cellar :any
    sha1 "b2d64e89dff33d0ddf55c30cb2bca1f015ac1d7a" => :yosemite
    sha1 "15905ff6a6324951e1b0d63761b8d1a4dac00861" => :mavericks
    sha1 "bb2094e4f4747dded749ddbb7d697cd7f9174740" => :mountain_lion
  end

  def install
    system "./bootstrap.sh"
    system "./b2", "--prefix=#{prefix}", "install"
  end
end
