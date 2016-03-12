class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/1.6.5.tar.gz"
  head "https://github.com/open-source-parsers/jsoncpp.git"
  sha256 "a2b121eaff56ec88cfd034d17685821a908d0d87bc319329b04f91a6552c1ac2"

  bottle do
    cellar :any
    revision 1
    sha256 "562a25c2b31a9b8e4fd3b1061ec3ce4d20f15082956ab7bb157cf2d945c13116" => :el_capitan
    sha256 "4d631f8d14543fde5c44cd565db6184d085a7f4ff8240e03033420ec4d467c38" => :yosemite
    sha256 "5f52ce3f6720cebb193c4f50c78434065e98f0336ea7920c171558786517fd21" => :mavericks
  end

  option :universal

  needs :cxx11

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    cmake_args = std_cmake_args
    cmake_args << "-DBUILD_STATIC_LIBS=ON" << "-DBUILD_SHARED_LIBS=ON" << "-DJSONCPP_WITH_CMAKE_PACKAGE=ON" << "-DJSONCPP_WITH_TESTS=OFF" << "-DJSONCPP_WITH_POST_BUILD_UNITTEST=OFF"
    if build.universal?
      ENV.universal_binary
      cmake_args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <json/json.h>
      int main() {
        Json::Value root;
        Json::Reader reader;
        return reader.parse("[1, 2, 3]", root) ? 0: 1;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                  "-I#{include}/jsoncpp",
                  "-L#{lib}",
                  "-ljsoncpp"
    system "./test"
  end
end
