require "formula"
class Geographiclib < Formula
  homepage "http://geographiclib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.38.tar.gz"
  sha1 "e854d6d85cc5b1273fa4044828fadd9e1b151fcd"

  bottle do
    cellar :any
    sha1 "f073cfb05702e53278e63e16e639e983f146339e" => :mavericks
    sha1 "6a29856e399ed02bdfe2ab359acf8b51236a460c" => :mountain_lion
    sha1 "4dec4fdcf143f0b9343aae0c6cc56d25a8b3e660" => :lion
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
