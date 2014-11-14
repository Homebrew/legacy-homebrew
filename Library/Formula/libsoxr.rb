require "formula"

class Libsoxr < Formula
  homepage "http://sourceforge.net/projects/soxr/"
  url "https://downloads.sourceforge.net/project/soxr/soxr-0.1.1-Source.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libs/libsoxr/libsoxr_0.1.1.orig.tar.xz"
  sha1 "f5d90e375db3914a522fef477898bde8c70243e7"

  depends_on "cmake" => :build

  conflicts_with "sox", :because => "Sox contains soxr. Soxr is purely the resampler."

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
