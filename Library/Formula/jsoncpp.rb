class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/0.10.5.tar.gz"
  sha256 "56afb14d2ef1c52e72771a221346d4b94f0d46d4e67f796bbcaedb176ca823df"

  bottle do
    cellar :any
    sha256 "a894c99bea07d28cb0a84aa325b8f203c68293e335522a109174eae9cb662dab" => :el_capitan
    sha256 "23e7bafcd961be747ab26c3d754f5723ba8a86d4915cf31bcaee002618898b18" => :yosemite
    sha256 "72c73a2a679f8196bed4fb65cfa04cbb16fa7a565901830f34c3a8d5734c3911" => :mavericks
    sha256 "7d3400af12dbe322fec3aab9894a920e68b711d01e6205767966ad102cbd8e14" => :mountain_lion
  end

  depends_on "scons" => :build

  def install
    gccversion = `g++ -dumpversion`.strip
    libs = buildpath/"libs/linux-gcc-#{gccversion}/"

    scons "platform=linux-gcc"
    system "install_name_tool", "-id", lib/"libjsoncpp.dylib", libs/"libjson_linux-gcc-#{gccversion}_libmt.dylib"

    lib.install libs/"libjson_linux-gcc-#{gccversion}_libmt.dylib" => "libjsoncpp.dylib"
    lib.install libs/"libjson_linux-gcc-#{gccversion}_libmt.a" =>"libjsoncpp.a"
    (include/"jsoncpp").install buildpath/"include/json"

    (lib/"pkgconfig/jsoncpp.pc").write <<-EOS.undent
      prefix=#{prefix}
      exec_prefix=${prefix}
      libdir=#{lib}
      includedir=#{include}

      Name: jsoncpp
      Description: API for manipulating JSON
      Version: #{version}
      URL: https://github.com/open-source-parsers/jsoncpp
      Libs: -L${libdir} -ljsoncpp
      Cflags: -I${includedir}/jsoncpp/
    EOS
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
