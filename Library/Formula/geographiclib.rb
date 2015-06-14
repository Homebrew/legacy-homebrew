require "formula"
class Geographiclib < Formula
  desc "C++ geography library"
  homepage "http://geographiclib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.43.tar.gz"
  sha1 "444650196e1e7fd18c7d3e184599d05be5221e57"

  bottle do
    cellar :any
    sha256 "71b8bbdd29951d7e32e690f9b03df844f2d3750f40211a0d80a54e55bc17d2e1" => :yosemite
    sha256 "9f88fd085316b05f7196de74780b9b7968481bb5810e2f157a626d8bc033a03d" => :mavericks
    sha256 "0759e226f6722727f6ea3f42999064b31fc660e8e881f7163a2dcf0881303941" => :mountain_lion
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
