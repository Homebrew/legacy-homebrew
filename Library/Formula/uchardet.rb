class Uchardet < Formula
  desc "Encoding detector library"
  homepage "https://github.com/BYVoid/uchardet"
  url "https://github.com/BYVoid/uchardet/archive/v0.0.5.tar.gz"
  sha256 "7c5569c8ee1a129959347f5340655897e6a8f81ec3344de0012a243f868eabd1"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DCMAKE_INSTALL_NAME_DIR=#{lib}"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/uchardet", __FILE__
  end
end
