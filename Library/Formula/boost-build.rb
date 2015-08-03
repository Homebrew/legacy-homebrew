class BoostBuild < Formula
  desc "C++ build system"
  homepage "http://boost.org/boost-build2/"
  url "https://github.com/boostorg/build/archive/2014.10.tar.gz"
  sha256 "d143297d61e7c628fc40c6117d0df41cb40b33845376c331d7574f9a79b72b9f"

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
