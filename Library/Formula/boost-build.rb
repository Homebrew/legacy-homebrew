class BoostBuild < Formula
  desc "C++ build system"
  homepage "http://boost.org/boost-build2/"
  url "https://github.com/boostorg/build/archive/2014.10.tar.gz"
  sha256 "d143297d61e7c628fc40c6117d0df41cb40b33845376c331d7574f9a79b72b9f"

  head "https://github.com/boostorg/build.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "54e173a7e91aef66bfdb5c497156915518d69dd9a062552ab48e62d443adaa04" => :el_capitan
    sha256 "a61eaa58a94a1f236d1dc6e652f7cb57e241e0dd5664bb5cadc258b73ce34887" => :yosemite
    sha256 "dd11acd551a6c26f216743eeb938d704f92bc5349c79b5f8e853176e311b7990" => :mavericks
    sha256 "03d989cecd3251825466d725f6a00212979b2d41fce344380606b482eaab9b80" => :mountain_lion
  end

  def install
    system "./bootstrap.sh"
    system "./b2", "--prefix=#{prefix}", "install"
  end
end
