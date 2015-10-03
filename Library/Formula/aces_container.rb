class AcesContainer < Formula
  desc "Reference implementation of SMPTE S2065-4"
  homepage "https://github.com/ampas/aces_container"
  url "https://github.com/ampas/aces_container/archive/v1.0.tar.gz"
  sha256 "9d310605ce15b03689b1e5b7b3cf735e236b4d11a78654018321ae593af69aba"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
