class Csfml < Formula
  # Don't update CSFML until there's a corresponding SFML release
  homepage "http://www.sfml-dev.org/"
  url "https://github.com/SFML/CSFML/archive/2.3.tar.gz"
  sha256 "ba8f5529fd264c2778844a8b1bb71ede7e902bbd6841275c344dc488ce7054cd"

  head "https://github.com/SFML/CSFML.git"

  bottle do
    cellar :any
    sha256 "81a7f3da157b8941df5ba58152846b62aefcfcb434bd3e2a259db63964d5765e" => :yosemite
    sha256 "48ffc9d13eec898937ad7cde0562f85694d6b7bf25a02f67efc50565788f179d" => :mavericks
    sha256 "65457acf802959c36830d5d812d1f3e63739e366249196d4bafe526e2bc254ea" => :mountain_lion
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
