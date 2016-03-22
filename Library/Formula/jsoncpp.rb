class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/1.6.5.tar.gz"
  head "https://github.com/open-source-parsers/jsoncpp.git"
  sha256 "a2b121eaff56ec88cfd034d17685821a908d0d87bc319329b04f91a6552c1ac2"

  bottle do
    cellar :any
    sha256 "ee0670a321326b422497c3844dde76154e87cb26bab9b5be49d2d26a5164513b" => :el_capitan
    sha256 "83d4c292d053abeee3769e3fba06baeedcc0d4ae6e84c1c64069ae7c62f6d199" => :yosemite
    sha256 "c8239ff5d50f0f7d200683ca4613dc271954226136cd4d6206ffc2583fab650b" => :mavericks
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
