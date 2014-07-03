require "formula"

class Libvidstab < Formula
  homepage "http://public.hronopik.de/vid.stab/"
  url "https://github.com/georgmartius/vid.stab/archive/release-0.98b.tar.gz"
  sha1 "1030a1baa9b2cba844758a6cd8dd5d5fc23f9cd9"

  bottle do
    cellar :any
    sha1 "1cabec8b4661d8118dfae224efc1edbfb6ae87f4" => :mavericks
    sha1 "08b6aa92e1dbc9baa82463fc59c9638baf7f8483" => :mountain_lion
    sha1 "b9e8d199d534d5aeb77df66e712613b3c70a5c91" => :lion
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
