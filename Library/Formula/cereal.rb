class Cereal < Formula
  homepage "https://uscilab.github.io/cereal/"
  url "https://github.com/USCiLab/cereal/archive/v1.1.0.tar.gz"
  sha1 "a7036f3fdb43315b0b6aa6c112c5878c03f1aa9e"

  head "https://github.com/USCiLab/cereal.git", :branch => "develop"

  bottle do
    cellar :any
    sha1 "6adcd84314611446fb8926455217e207a47993be" => :mavericks
    sha1 "5d9e8b45dbe08eaad5fe3088e70036a27d7ff581" => :mountain_lion
    sha1 "47344b6e499bf21f54f6a59a462a9ada773f8a5e" => :lion
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
