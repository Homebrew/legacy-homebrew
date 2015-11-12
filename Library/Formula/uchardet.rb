class Uchardet < Formula
  desc "Encoding detector library"
  homepage "https://code.google.com/p/uchardet/"
  url "https://uchardet.googlecode.com/files/uchardet-0.0.1.tar.gz"
  sha256 "e238c212350e07ebbe1961f8f128faaa40f71b70d37b63ffa2fe12c664269ee6"

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
