require "formula"

class Csfml < Formula
  homepage "http://www.sfml-dev.org/"
  url "http://www.sfml-dev.org/download/csfml/CSFML-2.0-sources.zip"
  sha1 "6d831634a558593580296209af278322523f1e43"

  bottle do
    cellar :any
    sha1 "cd9aa7a1b25776c479b28d590a47faeef3d9c998" => :mavericks
    sha1 "bbebd99be16cf18fb2d4c298148fd6b4a49d2d99" => :mountain_lion
    sha1 "5671fb2cd53398283e45761a101099dcbbe81a17" => :lion
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    cp_r "#{Formula["sfml"].share}/SFML/cmake/Modules/", "cmake"
    system "cmake", ".", *std_cmake_args
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
