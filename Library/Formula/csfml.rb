class Csfml < Formula
  # Don't update CSFML until there's a corresponding SFML release
  desc "SMFL bindings for C"
  homepage "http://www.sfml-dev.org/"
  url "https://github.com/SFML/CSFML/archive/2.3.tar.gz"
  sha256 "ba8f5529fd264c2778844a8b1bb71ede7e902bbd6841275c344dc488ce7054cd"

  head "https://github.com/SFML/CSFML.git"

  bottle do
    cellar :any
    sha256 "0f080fd2c809a1c22ba10aee92ccc34b201458e98de3b8c973cdf9fa99d8cf3e" => :yosemite
    sha256 "32e3cd01b497a73fb7d918841e4df0e980811270d92626d6399e47fae8291ea6" => :mavericks
    sha256 "afbda33ded196a5dd39ecc68627e6fb6db156ec7a67f71fb16a6d6cb4cd40531" => :mountain_lion
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
