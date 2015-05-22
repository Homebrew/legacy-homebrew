require "formula"
class Geographiclib < Formula
  homepage "http://geographiclib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.42.tar.gz"
  sha1 "cb1cd87d0e00bffb1d9192d13e83b38deb1a4266"

  bottle do
    cellar :any
    sha256 "85974a3b1c23fd85879e1c1e0afeebd0d13302f832aecf18278d03fb64fc0ae3" => :yosemite
    sha256 "d07574775c89c45ff11322fbcca088b0834852ceb4ff034c5352c3bbfeceeaed" => :mavericks
    sha256 "ea3cee78c323be2dce4ac5f3d3e7206fd737dc9bdbd5788fc0bd3d72ec3789be" => :mountain_lion
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
