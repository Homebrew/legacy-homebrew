class Libreplaygain < Formula
  desc "Library to implement ReplayGain standard for audio"
  homepage "https://www.musepack.net/"
  url "http://files.musepack.net/source/libreplaygain_r475.tar.gz"
  version "r475"
  sha256 "8258bf785547ac2cda43bb195e07522f0a3682f55abe97753c974609ec232482"

  bottle do
    cellar :any
    revision 1
    sha256 "d47338c5b86daabf3e2e05ab9dd2443c04c1233f3319307e8e5d545b24dcf722" => :yosemite
    sha256 "dc3f2c3823c5552bddad7b1727b9086dc2fe79e8fa13987b420d1621c97e2bce" => :mavericks
    sha256 "4ce4390dc0c3ba503381bf256b942207dc706fc2e8e9e464aceb7ecf916f9841" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    include.install "include/replaygain/"
  end
end
