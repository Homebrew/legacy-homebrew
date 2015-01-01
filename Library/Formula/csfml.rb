require "formula"

class Csfml < Formula
  homepage "http://www.sfml-dev.org/"
  # CSFML 2.1 and SFML 2.2 are incompatible with each other
  # Making CSFML 2.1 build requires multiple patches
  # Until there is no newer relese, this formula uses fixed revision from master
  # Also, see: https://github.com/LaurentGomila/CSFML/issues/50
  url "https://github.com/LaurentGomila/CSFML.git", :revision => "848b4d3aaa7646c4742222489416ced48335274f"
  version "2.1-848b4d3aaa7646c4742222489416ced48335274f"

  bottle do
    cellar :any
    sha1 "cd9aa7a1b25776c479b28d590a47faeef3d9c998" => :mavericks
    sha1 "bbebd99be16cf18fb2d4c298148fd6b4a49d2d99" => :mountain_lion
    sha1 "5671fb2cd53398283e45761a101099dcbbe81a17" => :lion
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    system "cmake", ".", *std_cmake_args, "-DCMAKE_MODULE_PATH=#{Formula["sfml"].share}/SFML/cmake/Modules/"
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
