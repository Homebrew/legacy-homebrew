class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/0.10.5.tar.gz"
  head "https://github.com/open-source-parsers/jsoncpp.git"
  sha256 "56afb14d2ef1c52e72771a221346d4b94f0d46d4e67f796bbcaedb176ca823df"

  bottle do
    cellar :any
    revision 1
    sha256 "562a25c2b31a9b8e4fd3b1061ec3ce4d20f15082956ab7bb157cf2d945c13116" => :el_capitan
    sha256 "4d631f8d14543fde5c44cd565db6184d085a7f4ff8240e03033420ec4d467c38" => :yosemite
    sha256 "5f52ce3f6720cebb193c4f50c78434065e98f0336ea7920c171558786517fd21" => :mavericks
  end

  option :universal

  depends_on "cmake" => :build

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DBUILD_STATIC_LIBS=ON" << "-DBUILD_SHARED_LIBS=ON" << "-DJSONCPP_WITH_CMAKE_PACKAGE=ON"
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
