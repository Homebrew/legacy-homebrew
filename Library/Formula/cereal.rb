require "formula"

class Cereal < Formula
  homepage "http://uscilab.github.io/cereal/"
  url "https://github.com/USCiLab/cereal/archive/v1.0.0.tar.gz"
  sha1 "a8e409deb2bdba6bdbc04d3eb2d5294d4cc4b9e2"

  head "https://github.com/USCiLab/cereal.git", :branch => "develop"

  option "with-tests", "Build and run the test suite"

  depends_on "cmake" => :build if build.with? "tests"

  def install
    if build.with? "tests"
      system "cmake", ".", *std_cmake_args
      system "make"
      system "make", "test"
    end
    include.install "include/cereal"
  end
end
