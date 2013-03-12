require 'formula'

class Jsoncpp < Formula
  homepage 'http://jsoncpp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/jsoncpp/jsoncpp/0.5.0/jsoncpp-src-0.5.0.tar.gz'
  sha1 '7169a50c7615070b6190076a7b5e86c45b7440b7'

  depends_on 'scons' => :build

  def install
    gccversion = `g++ -dumpversion`
    gccversion = gccversion.delete("\n");
    system "scons platform=linux-gcc"
    # make some directories need for install
    system "mkdir -p lib include/include"
    # copy the libraries to the right directory with easier file names
    system "cp -f libs/linux-gcc-#{gccversion}/libjson_linux-gcc-#{gccversion}_libmt.a lib/libjsoncpp.a"
    system "cp -f libs/linux-gcc-#{gccversion}/libjson_linux-gcc-#{gccversion}_libmt.dylib lib/libjsoncpp.dylib"
    # copy the header files to a more unique folder name
    system "cp -r include/json include/include/jsoncpp"
    prefix.install Dir["lib"], Dir["include/include"]
  end

  test do
    system "scons platform=linux-gcc check"
  end
end
