class Libstxxl < Formula
  desc "C++ implementation of STL for extra large data sets"
  homepage "http://stxxl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/stxxl/stxxl/1.4.1/stxxl-1.4.1.tar.gz"
  sha256 "92789d60cd6eca5c37536235eefae06ad3714781ab5e7eec7794b1c10ace67ac"

  bottle do
    cellar :any
    sha1 "2e9e956e2b3500e526a119b980c2854535d5edb0" => :yosemite
    sha1 "50fcd3bca1975e47922a986e7fba52e24e49ae55" => :mavericks
    sha1 "1d54cfe7453bc91b00dfefbe23839a61e376d6c5" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args - %w[-DCMAKE_BUILD_TYPE=None]
    args << "-DCMAKE_BUILD_TYPE=Release"
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
