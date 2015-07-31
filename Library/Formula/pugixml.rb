class Pugixml < Formula
  desc "Pugixml is a light-weight C++ XML processing library"
  homepage "http://pugixml.org"
  url "https://github.com/zeux/pugixml/releases/download/v1.6/pugixml-1.6.tar.gz"
  sha256 "473705c496d45ee6a74f73622b175dfb5dde0de372c4dc61a5acb964516cd9de"

  option "with-shared", "Build shared instead of static library"

  depends_on "cmake" => :build

  def install
    shared = (build.with? "shared") ? "ON" : "OFF"

    args = std_cmake_args
    args << "-DBUILD_SHARED_LIBS=#{shared}"

    cd "scripts" do
      system "cmake", ".", *args
      system "make", "install"
    end

    (lib/"pkgconfig/pugixml.pc").write pc_file
  end

  def pc_file; <<-EOS.undent
    prefix=#{HOMEBREW_PREFIX}
    exec_prefix=${prefix}
    libdir=${exec_prefix}/lib
    includedir=${exec_prefix}/include

    Name: pugixml
    Description: Pugixml is a light-weight C++ XML processing library
    Version: 1.6
    Libs: -L${libdir} -lpugixml
    Cflags: -I${includedir}
    EOS
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <pugixml.hpp>
      #include <cassert>
      #include <cstring>

      int main(int argc, char *argv[]) {
        pugi::xml_document doc;
        pugi::xml_parse_result result = doc.load_file("test.xml");

        assert(result);
        assert(strcmp(doc.child_value("root"), "Hello world!") == 0);
      }
    EOS

    (testpath/"test.xml").write <<-EOS.undent
      <root>Hello world!</root>
    EOS

    system ENV.cc, "test.cpp", "-L#{lib}", "-lpugixml", "-lstdc++", "-o", "test"
    system "./test"
  end
end
