require "formula"

class Libbtbb < Formula
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2014-02-R2.tar.gz"
  sha1 "aa94b7d92465704aa647123f11e906491a26d090"
  version "2014-02-R2"

  head "https://github.com/greatscottgadgets/libbtbb.git"

  bottle do
    cellar :any
    sha1 "a845a9b2f08b398f965e377710fcefe85732cc7d" => :mavericks
    sha1 "41deb429b9c4b4fb5b06678db333c47c343fe19f" => :mountain_lion
    sha1 "e46bb90fd4bf1954857bfef864fd6839114e9b50" => :lion
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "python"

  def install
    args = std_cmake_args

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
