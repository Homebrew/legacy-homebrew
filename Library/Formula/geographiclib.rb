require "formula"
class Geographiclib < Formula
  homepage "http://geographiclib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.38.tar.gz"
  sha1 "e854d6d85cc5b1273fa4044828fadd9e1b151fcd"

  bottle do
    sha1 "bfa37887453c33dc76cc1005e3accae3720ea227" => :mavericks
    sha1 "6daf6c3be855c49c0b2eab5d2c1de502dbeb982c" => :mountain_lion
    sha1 "7d1d3266f3b3f6398a413a170ee36ca8376a5357" => :lion
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
