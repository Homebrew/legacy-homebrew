class Cereal < Formula
  desc "C++11 library for serialization"
  homepage "https://uscilab.github.io/cereal/"
  url "https://github.com/USCiLab/cereal/archive/v1.1.0.tar.gz"
  sha1 "a7036f3fdb43315b0b6aa6c112c5878c03f1aa9e"

  head "https://github.com/USCiLab/cereal.git", :branch => "develop"

  bottle do
    cellar :any
    sha1 "e7bbce282665e7e1d392840a1a620371de9fb3af" => :yosemite
    sha1 "2d1bc4e43e82c55eb57cf767683fb7223ab05fef" => :mavericks
    sha1 "2b53401c5d32d2d6263678e2166db000df7dc013" => :mountain_lion
  end

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
