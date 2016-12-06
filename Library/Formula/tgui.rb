class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "http://tgui.eu"
  url "https://github.com/texus/TGUI/archive/v0.7-alpha2.tar.gz"
  version "0.7-alpha2"
  sha256 "dc4505a65f1ff7793a41a9a70c040275fc225c61db0d2c516d67007bcfd2c953"

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <TGUI/TGUI.hpp>
      int main()
      {
        sf::Text text;
        text.setString("Hello World");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-I#{include}", "-L#{lib}", "-L#{HOMEBREW_PREFIX}/lib", "-ltgui", "-lsfml-graphics", "-lsfml-system", "-lsfml-window", "-o", "test"
    system "./test"
  end
end
