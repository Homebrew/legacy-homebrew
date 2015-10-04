class Libreplaygain < Formula
  desc "Library to implement ReplayGain standard for audio"
  homepage "http://www.musepack.net/"
  url "http://files.musepack.net/source/libreplaygain_r475.tar.gz"
  version "r475"
  sha256 "8258bf785547ac2cda43bb195e07522f0a3682f55abe97753c974609ec232482"

  bottle do
    cellar :any
    revision 1
    sha1 "0e4609d3d583c0fd642e3d23185f690d9277f5c4" => :yosemite
    sha1 "5bbd2faa6fd01aeb9e4a4ecd30e46d5ef98f0418" => :mavericks
    sha1 "6baabf93ea2d9d9188081b92894736b26ca57ecd" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    include.install "include/replaygain/"
  end
end
