require "formula"

class Csfml < Formula
  homepage "http://www.sfml-dev.org/"
  url "http://www.sfml-dev.org/download/csfml/CSFML-2.2-sources.zip"
  sha1 "1dc3d2dadef6e6daa05b0dd868367ad5f02419e4"

  bottle do
    cellar :any
    sha1 "cd9aa7a1b25776c479b28d590a47faeef3d9c998" => :mavericks
    sha1 "bbebd99be16cf18fb2d4c298148fd6b4a49d2d99" => :mountain_lion
    sha1 "5671fb2cd53398283e45761a101099dcbbe81a17" => :lion
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
