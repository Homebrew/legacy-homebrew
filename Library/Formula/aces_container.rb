require "formula"

class AcesContainer < Formula
  homepage "https://github.com/ampas/aces_container"
  url "https://github.com/ampas/aces_container/archive/v1.0.tar.gz"
  sha1 "48409883970bab42a1fbac9dc5c7bac96c8bacb3"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
