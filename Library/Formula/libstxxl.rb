require "formula"

class Libstxxl < Formula
  homepage "http://stxxl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/stxxl/stxxl/1.4.1/stxxl-1.4.1.tar.gz"
  sha1 "cb29de8d33c7603734fa86215723da676a51dbf1"

  bottle do
    cellar :any
    revision 2
    sha1 "7ce7a89ba656cd26a64ffedcaeda2f35c06ef01a" => :yosemite
    sha1 "6a2ee5d2a7b32c1195e7aa0f48630cbb66f10adf" => :mavericks
    sha1 "3275c9447279ebbcbdceda59fd7ad3d99fc7afbb" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args - %w{-DCMAKE_BUILD_TYPE=None}
    args << "-DCMAKE_BUILD_TYPE=Release"
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
