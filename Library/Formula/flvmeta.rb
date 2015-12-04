class Flvmeta < Formula
  desc "Manipulate Adobe flash video files (FLV)"
  homepage "http://www.flvmeta.com"
  url "https://github.com/noirotm/flvmeta/archive/v1.1.2.tar.gz"
  sha256 "ee98c61e08b997b96d9ca4ea20ee9cff2047d8875d09c743d97b1b1cc7b28d13"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/flvmeta", "-V"
  end
end
