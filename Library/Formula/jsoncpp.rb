require 'formula'

class Jsoncpp < Formula
  homepage 'http://jsoncpp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/jsoncpp/jsoncpp/0.5.0/jsoncpp-src-0.5.0.tar.gz'
  sha1 '7169a50c7615070b6190076a7b5e86c45b7440b7'

  depends_on 'scons' => :build

  def install
    # this is how the SConstruct build system creates file paths
    gccversion = `g++ -dumpversion`
    gccversion = gccversion.delete("\n");
    # run the build
    system "scons platform=linux-gcc"
    #install the libs
    lib.install "libs/linux-gcc-#{gccversion}/libjson_linux-gcc-#{gccversion}_libmt.a" => "libjsoncpp.a", 
    "libs/linux-gcc-#{gccversion}/libjson_linux-gcc-#{gccversion}_libmt.dylib" => "libjsoncpp.dylib"
    # install the headers
    include.install "include/json" => "jsoncpp"
  end

  test do
    system "false"
  end
end
