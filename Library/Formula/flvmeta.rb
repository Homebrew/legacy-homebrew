require "formula"

class Flvmeta < Formula
  homepage "http://www.flvmeta.com"
  url "https://github.com/noirotm/flvmeta/archive/v1.1.2.tar.gz"
  sha1 "114a6b5b9681bcc6d0cd56ce176cb89002e262ff"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/flvmeta", "-V"
  end
end
