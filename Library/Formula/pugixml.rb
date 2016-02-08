class Pugixml < Formula
  desc "Pugixml is a light-weight C++ XML processing library"
  homepage "http://pugixml.org"
  url "https://github.com/zeux/pugixml/releases/download/v1.7/pugixml-1.7.tar.gz"
  sha256 "fbe10d46f61d769f7d92a296102e4e2bd3ee16130f11c5b10a1aae590ea1f5ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "c21e9b8750463c6b5e232c40e695095327fc8afe855d8b8e149d4ea0eccc204d" => :el_capitan
    sha256 "400c5afde63177b4a7c40d665a3a052d1e10ddfdc69c5d5ee97c2542fc1117b5" => :yosemite
    sha256 "6d0abed138bda13d447f4f800f4d0154efb5d34315bbe6f2d49193bac410409c" => :mavericks
  end

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
    Version: 1.7
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
