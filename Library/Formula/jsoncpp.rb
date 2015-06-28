require "formula"

class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/0.10.2-p1.tar.gz"
  sha256 "43fe64ffb0630ac3530547e2c4dcec1bfcdf48bdb5b53a0f4971ee420b39c2be"
  version "0.10.2-p1"

  bottle do
    cellar :any
    sha1 "701adf90e494bfabf0bc54b9d3628fb125bd1244" => :yosemite
    sha1 "c6cd33fe89d9b91c1864dc7e8158a507199c1454" => :mavericks
    sha1 "d315e5fab004b81e068a624c37fb0afc6b4318b2" => :mountain_lion
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
