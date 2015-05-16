require "formula"

class Libvidstab < Formula
  homepage "http://public.hronopik.de/vid.stab/"
  url "https://github.com/georgmartius/vid.stab/archive/release-0.98b.tar.gz"
  sha1 "1030a1baa9b2cba844758a6cd8dd5d5fc23f9cd9"

  bottle do
    cellar :any
    revision 1
    sha1 "57958e5826781bbf10929f918c36a2ac54dc52bd" => :yosemite
    sha1 "be60ee3921484efe3f90495b24046437c84498b5" => :mavericks
    sha1 "05e50798e9cf4120ae96dba00f1fed578f481cf0" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
