require "formula"

class Csfml < Formula
  homepage "http://www.sfml-dev.org/"
  url "http://www.sfml-dev.org/download/csfml/CSFML-2.0-sources.zip"
  sha1 "6d831634a558593580296209af278322523f1e43"

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    cp_r "#{Formula["sfml"].share}/SFML/cmake/Modules/", "cmake"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    fixture = <<-EOS.undent
      #include <SFML/Window.h>

      int main (void)
      {
        sfWindow * w = sfWindow_create (sfVideoMode_getDesktopMode (), "Test", 0, NULL);
        return 0;
      }
    EOS
    (testpath/'test.c').write(fixture)
    system ENV.cc, "-c", "test.c"
  end
end
