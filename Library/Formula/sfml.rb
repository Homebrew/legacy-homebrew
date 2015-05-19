class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  homepage "http://www.sfml-dev.org/"
  url "http://www.sfml-dev.org/files/SFML-2.3-sources.zip"
  sha256 "a1dc8b00958000628c5394bc8438ba1aa5971fbeeef91a2cf3fa3fff443de7c1"

  head "https://github.com/SFML/SFML.git"

  bottle do
    cellar :any
    sha256 "aa333dcea990b993dea2b2e6eaf814ea21dce35fd22fc109fffa376b24337203" => :yosemite
    sha256 "0d1eaaf926fbcfc14b32929aaa3d42862722cc0ef9e3e3dcd3b5bf171048770f" => :mavericks
    sha256 "7471263a9b8cbc9694aa5ad4d5f563cd54119770b6a0be5a8dd2a7d9c9d3dffd" => :mountain_lion
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
