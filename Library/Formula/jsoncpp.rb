require "formula"

class Jsoncpp < Formula
  homepage "http://sourceforge.net/projects/jsoncpp/"
  url "https://downloads.sourceforge.net/project/jsoncpp/jsoncpp/0.6.0-rc2/jsoncpp-src-0.6.0-rc2.tar.gz"
  sha1 "a14eb501c44e610b8aaa2962bd1cc1775ed4fde2"

  depends_on "scons" => :build

  def install
    # linux-gcc is correct - despite the fact that the library is built with CLANG (see README.txt).
    scons "platform=linux-gcc"
    gccVersion = `#{ENV.cc} -dumpversion`.chomp

    lib.install "libs/linux-gcc-#{gccVersion}/libjson_linux-gcc-#{gccVersion}_libmt.dylib" => "libjsoncpp.dylib"
    lib.install "libs/linux-gcc-#{gccVersion}/libjson_linux-gcc-#{gccVersion}_libmt.a" => "libjsoncpp.a"
    prefix.install "include"

    # Due to problems with the build system homebrew does not automatically fix this library reference.
    system "install_name_tool", "-change",
      "buildscons/linux-gcc-#{gccVersion}/src/lib_json/libjson_linux-gcc-#{gccVersion}_libmt.dylib",
      "#{HOMEBREW_PREFIX}/lib/libjsoncpp.dylib",
      "bin/linux-gcc-#{gccVersion}/test_lib_json"

    bin.install Dir["bin/linux-gcc*/test_lib_json"] => "test_lib_json"
  end

  test do
    system "#{bin}/test_lib_json"
  end
end
