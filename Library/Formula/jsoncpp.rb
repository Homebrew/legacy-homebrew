require "formula"

class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/svn-release-0.6.0-rc2.tar.gz"
  sha1 "6cc51ed1f31e742637a512201b585e0bc4e06980"

  bottle do
    cellar :any
    sha1 "701adf90e494bfabf0bc54b9d3628fb125bd1244" => :yosemite
    sha1 "c6cd33fe89d9b91c1864dc7e8158a507199c1454" => :mavericks
    sha1 "d315e5fab004b81e068a624c37fb0afc6b4318b2" => :mountain_lion
  end

  depends_on "scons" => :build

  patch :p1 do
    # use the usual environment variables for the compilation flags
    url "https://github.com/open-source-parsers/jsoncpp/pull/55.patch"
    sha1 "d2e985a0877fc811acfb34f62713a35ba4742452"
  end

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
