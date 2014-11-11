require "formula"
class Geographiclib < Formula
  homepage "http://geographiclib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.38.tar.gz"
  sha1 "e854d6d85cc5b1273fa4044828fadd9e1b151fcd"

  bottle do
    cellar :any
    revision 1
    sha1 "1f091f2ac6bc3dbaeb40ba2cf1052cfb2170e733" => :yosemite
    sha1 "fa1aab22b859ee25bec1e91b868553d57cda76da" => :mavericks
    sha1 "a0c31b8e51e44175a07bc22ba7917621231593cd" => :mountain_lion
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
