require "formula"
class Geographiclib < Formula
  homepage "http://geographiclib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.41.tar.gz"
  sha1 "f1ff824f0e8bc30dd349bf21d2cd54a5630c87f6"

  bottle do
    cellar :any
    sha1 "0b2b506277d3db7a2877b27ec016bd428ec92cad" => :yosemite
    sha1 "eee6cc9c28406055baee1acc616288a45a268fe9" => :mavericks
    sha1 "e74d8493c187c2d0a42357796156b086a6f97c68" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
  end
end
