require "formula"

class Csfml < Formula
  homepage "http://www.sfml-dev.org/"
  url "http://www.sfml-dev.org/download/csfml/CSFML-2.2-sources.zip"
  sha1 "1dc3d2dadef6e6daa05b0dd868367ad5f02419e4"

  bottle do
    cellar :any
    sha256 "4cc1bc694356a8206e1164cc266ef68b5c45e7a1ee60d0e210c4a8e49c6abb97" => :yosemite
    sha256 "d1d8e0343fe42fd91029a770cdf912587fbf7388ea997d68ec4f96f33548cb77" => :mavericks
    sha256 "3ecb8338214a6c0485fe294af23c4ec8440e35878ef0521a4fe6d6da792e6c77" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    system "cmake", ".", "-DCMAKE_MODULE_PATH=#{Formula["sfml"].share}/SFML/cmake/Modules/", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <SFML/Window.h>

      int main (void)
      {
        sfWindow * w = sfWindow_create (sfVideoMode_getDesktopMode (), "Test", 0, NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lcsfml-window", "-o", "test"
    system "./test"
  end
end
