require "formula"

class BoostBuild < Formula
  homepage "http://boost.org/boost-build2/"
  url "https://github.com/boostorg/build/archive/2014.10.tar.gz"
  sha1 "64f59424b829e9b5741bda58c78d830c993a0042"

  head "https://github.com/boostorg/build.git"

  bottle do
    cellar :any
    sha1 "e1ab34b88ac324bfa985d91a857ecdcd86e06541" => :yosemite
    sha1 "0d8f9f91809f3b3b7b5eeb5e70cb92ed2a7ec42b" => :mavericks
    sha1 "19db795fdbbcbc4f5916e8c9d249fe0c05bad1b5" => :mountain_lion
  end

  def install
    system "./bootstrap.sh"
    system "./b2", "--prefix=#{prefix}", "install"
  end
end
