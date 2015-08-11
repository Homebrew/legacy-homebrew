
class Mytget < Formula
  desc "Mytget is a muti-thread downloader accelerator for GNU/Linux. "
  homepage "https://github.com/lytsing/mytget"
  url "https://github.com/lytsing/mytget/archive/v1.1.2.tar.gz"
  version "1.1.2"
  sha256 "ac369d9c8ef99933973d108c9a1f5774cfcc9ddcc33267a619bffaa885f2824e"

  depends_on "cmake" => :build

  def install

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"wytget", "https://google.com"
  end
end

