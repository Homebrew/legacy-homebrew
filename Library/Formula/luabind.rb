class Luabind < Formula
  desc "Library for bindings between C++ and Lua"
  homepage "http://www.rasterbar.com/products/luabind.html"
  url "https://downloads.sourceforge.net/project/luabind/luabind/0.9.1/luabind-0.9.1.tar.gz"
  sha256 "80de5e04918678dd8e6dac3b22a34b3247f74bf744c719bae21faaa49649aaae"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "a91678a0e7830fdaebdebeb315b4e4480ca5eb12f16aa6e6534fd79c30f203dc" => :el_capitan
    sha256 "57f0368918d142bba0d28ba02529cbf51eb6be30321ab001922032fbaabe583b" => :yosemite
    sha256 "bdb3e0380687c7943c13986b054bce3ae7c53db72394b5f4bec3e40a649f08b8" => :mavericks
  end

  depends_on "boost-build" => :build
  depends_on "lua51"
  depends_on "boost"

  # boost 1.57 compatibility
  # https://github.com/Homebrew/homebrew/pull/33890#issuecomment-67723688
  # https://github.com/luabind/luabind/issues/27
  patch do
    url "https://gist.githubusercontent.com/tdsmith/e6d9d3559ec1d9284c0b/raw/4ac01936561ef9d7541cf8e78a230bebef1a8e10/luabind.diff"
    sha256 "f22a283752994e821922316a5ef3cbb16f7bbe15fc64d97c02325ed4aaa53985"
  end

  # patch Jamroot to perform lookup for shared objects with .dylib suffix
  patch do
    url "https://gist.githubusercontent.com/DennisOSRM/3728987/raw/052251fcdc23602770f6c543be9b3e12f0cac50a/Jamroot.diff"
    sha256 "bc06d76069d08af4dc55a102f963931a0247173a36ad0ae43e11d82b23f8d2b3"
  end

  # apply upstream commit to enable building with clang
  patch do
    url "https://github.com/luabind/luabind/commit/3044a9053ac50977684a75c4af42b2bddb853fad.diff"
    sha256 "00476ab7d918cc118e83ced427bac48de81ae8c2d3445d6f77e556b5d8bded5f"
  end

  # include C header that is not pulled in automatically on OS X 10.9 anymore
  # submitted https://github.com/luabind/luabind/pull/20
  if MacOS.version >= :mavericks
    patch do
      url "https://gist.githubusercontent.com/DennisOSRM/a246514bf7d01631dda8/raw/0e83503dbf862ebfb6ac063338a6d7bca793f94d/object_rep.diff"
      sha256 "2fef524ac5e319d7092fbb28f6d4e3d3eccd6a570e7789a9b5b0c9a25e714523"
    end
  end

  def install
    ENV["LUA_PATH"] = Formula["lua51"].opt_prefix

    args = %W[release install]
    if ENV.compiler == :clang
      args << "--toolset=clang"
    elsif ENV.compiler == :llvm
      args << "--toolset=llvm"
    elsif ENV.compiler == :gcc
      args << "--toolset=darwin"
    end
    args << "--prefix=#{prefix}"
    system "bjam", *args

    (lib/"pkgconfig/luabind.pc").write pc_file
  end

  def pc_file; <<-EOS.undent
    prefix=#{HOMEBREW_PREFIX}
    exec_prefix=${prefix}
    libdir=${exec_prefix}/lib
    includedir=${exec_prefix}/include

    Name: luabind
    Description: Library for bindings between C++ and Lua
    Version: 0.9.1
    Libs: -L${libdir} -lluabind
    Cflags: -I${includedir}
    EOS
  end

  test do
    (testpath/"hello.cpp").write <<-EOS.undent
      extern "C" {
      #include <lua.h>
      }
      #include <iostream>
      #include <luabind/luabind.hpp>
      void greet() { std::cout << "hello world!\\n"; }
      extern "C" int init(lua_State* L)
      {
          using namespace luabind;
          open(L);
          module(L)
          [
              def("greet", &greet)
          ];
          return 0;
      }
    EOS
    system ENV.cxx, "-shared", "-o", "hello.dylib", "-I#{HOMEBREW_PREFIX}/include/lua-5.1",
           testpath/"hello.cpp", "-lluabind", "-llua5.1"
    assert_match /hello world!/, `lua5.1 -e "package.loadlib('#{testpath}/hello.dylib', 'init')(); greet()"`
  end
end
