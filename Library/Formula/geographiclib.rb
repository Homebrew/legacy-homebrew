class Geographiclib < Formula
  desc "C++ geography library"
  homepage "http://geographiclib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.44.tar.gz"
  sha256 "f0423318fb30959632f403935827e06856737cf4621695ecc27fa9c251db9d37"

  bottle do
    cellar :any
    sha256 "bac30c5ed336263cc2c702a4f215b46737b2a65db963de9389dc76bc5fe7a6e1" => :el_capitan
    sha256 "5835892b418d17e5c082d0386fc76a3507740f5350e16d6b1b454258e236ace2" => :yosemite
    sha256 "4d3396d27b6d87046dcb278a97e3be642617f48907dd3f64176e8638623c05cd" => :mavericks
    sha256 "c6024ea22fbb2dc922cf12e8d7b56a62ce19de4c624c76f8636e52026a5c066e" => :mountain_lion
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
