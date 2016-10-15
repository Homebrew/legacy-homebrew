require "formula"

class Catimg < Formula
  homepage "https://github.com/posva/catimg"
  url "https://github.com/posva/catimg/archive/1.0.tar.gz"
  sha1 "c0598b0132d02f10291935847e3b7f6f62881590"

  depends_on "cmake" => :build

  head do
    url "https://github.com/posva/catimg.git"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/catimg", "-h"
  end
end
