class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  desc "Multi-media library with bindings for multiple languages"
  homepage "http://www.sfml-dev.org/"
  url "http://www.sfml-dev.org/files/SFML-2.3-sources.zip"
  sha256 "a1dc8b00958000628c5394bc8438ba1aa5971fbeeef91a2cf3fa3fff443de7c1"

  head "https://github.com/SFML/SFML.git"

  bottle do
    cellar :any
    sha256 "3a945776dbc66b4e304853fe09a41b43f1da4047427e37a21c3402332b41d2ff" => :yosemite
    sha256 "7c7e3eeb9f700ecf56e4ce68406dfe9be1c3a614f6ce156a45057e421bd08d60" => :mavericks
    sha256 "1dd68903fa88cf39d3d12d9380d0bfb9c10585d2970b2cca24597e8c3604acf8" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :optional
  depends_on "flac"
  depends_on "freetype"
  depends_on "glew"
  depends_on "jpeg"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "openal-soft"

  # https://github.com/Homebrew/homebrew/issues/40301
  depends_on :macos => :lion

  def install
    args = std_cmake_args
    args << "-DSFML_BUILD_DOC=TRUE" if build.with? "doxygen"

    # Always remove the "extlibs" to avoid install_name_tool failure
    # (https://github.com/Homebrew/homebrew/pull/35279) but leave the
    # headers that were moved there in https://github.com/SFML/SFML/pull/795
    rm_rf Dir["extlibs/*"] - ["extlibs/headers"]

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include "Time.hpp"
      int main() {
        sf::Time t1 = sf::milliseconds(10);
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}/SFML/System", "-L#{lib}", "-lsfml-system",
           testpath/"test.cpp", "-o", "test"
    system "./test"
  end
end
