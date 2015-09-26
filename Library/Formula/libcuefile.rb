class Libcuefile < Formula
  desc "Library to work with CUE files"
  homepage "http://www.musepack.net/"
  url "http://files.musepack.net/source/libcuefile_r475.tar.gz"
  sha256 "b681ca6772b3f64010d24de57361faecf426ee6182f5969fcf29b3f649133fe7"
  version "r475"

  bottle do
    cellar :any
    revision 1
    sha1 "94ce9119cf192c06749060b884ed4cab915b65bb" => :yosemite
    sha1 "99d877483270168cbaad5e655f6bad25fe597417" => :mavericks
    sha1 "ed1826e08384d65caced5d38d4c8ad9b6b972e4b" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    include.install "include/cuetools/"
  end
end
