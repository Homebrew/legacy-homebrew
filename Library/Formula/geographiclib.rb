require "formula"
class Geographiclib < Formula
  homepage "http://geographiclib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.41.tar.gz"
  sha1 "f1ff824f0e8bc30dd349bf21d2cd54a5630c87f6"

  bottle do
    cellar :any
    sha256 "4b63ee2a41d497463011f7a9edcc1d1c011b2f35153e59818a787a5e7429b821" => :yosemite
    sha256 "12da0209d90c749ba463a3c87daf1025253709fd90b5bb1fbd55d7fbf93ab2e4" => :mavericks
    sha256 "f65d005f4bcec64175f413d2eedef5d561007f66a791333184806594cd426e45" => :mountain_lion
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
