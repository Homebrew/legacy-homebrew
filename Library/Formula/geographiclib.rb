require "formula"
class Geographiclib < Formula
  homepage "http://geographiclib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.39.tar.gz"
  sha1 "7a48a773997abce598e9c42ae8848e4c20f6ae72"

  bottle do
    cellar :any
    sha1 "6e2170f18e90c7ab765f5a78630d3da9aa1a6770" => :yosemite
    sha1 "0b750f088ea24d9f348d452ace17d146a62b2fc7" => :mavericks
    sha1 "62e3b10e42507475cee8b28376cd94f23ee30ca4" => :mountain_lion
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
