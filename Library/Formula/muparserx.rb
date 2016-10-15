class Muparserx < Formula
  homepage "http://muparser.beltoforion.de/"

  stable do
    url "https://muparserx.googlecode.com/files/muparserx_v2_1_6.zip"
    sha1 "f5b6ed13594c14f408168f6c0111ba4078e4b12f"
  end
  head "http://muparserx.googlecode.com/svn/trunk/"

  depends_on "cmake" => :build

  def install
    (buildpath/"CMakeLists.txt").write <<-EOS.undent
      cmake_minimum_required(VERSION 2.8)
      aux_source_directory(parser SRC)
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
      add_library(Parser-dynamic SHARED ${SRC})
      add_library(Parser-static ${SRC})
      set_target_properties(Parser-dynamic Parser-static PROPERTIES OUTPUT_NAME muparserx ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib" LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
    EOS
    system "cmake", "."
    system "make"
    lib.install Dir["lib/**"]
    (include/"muparserx").install Dir["parser/*.h"]
  end

  test do
    (testpath/"main.cpp").write <<-EOS.undent
      #include <muparserx/mpParser.h>
      int main()
      {
         mup::ParserX parser;
         return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}", "-lmuparserx", "main.cpp", "-o", "test"
    system "./test"
  end
end
