require 'formula'

class Luabind < Formula
  homepage 'http://www.rasterbar.com/products/luabind.html'
  url 'https://downloads.sourceforge.net/project/luabind/luabind/0.9.1/luabind-0.9.1.tar.gz'
  sha1 '2e92a18b8156d2e2948951d429cd3482e7347550'
  bottle do
    cellar :any
    sha1 "aa32def1a41203aa36c907e55aa48741927e4de8" => :yosemite
    sha1 "6c7fe3fd06a62aa7e8cd37775ca52c101fa045bb" => :mavericks
    sha1 "dbe4488b6e323e142684949abb1589de9490ca7e" => :mountain_lion
  end

  revision 1

  depends_on 'lua51'
  depends_on 'boost'
  depends_on 'boost-build' => :build

  # boost 1.57 compatibility
  # https://github.com/Homebrew/homebrew/pull/33890#issuecomment-67723688
  # https://github.com/luabind/luabind/issues/27
  patch do
    url "https://gist.githubusercontent.com/tdsmith/e6d9d3559ec1d9284c0b/raw/4ac01936561ef9d7541cf8e78a230bebef1a8e10/luabind.diff"
    sha1 "1f68317f840fb4e72fddbd94e0b2f57efc3df9e4"
  end

  # patch Jamroot to perform lookup for shared objects with .dylib suffix
  patch do
    url "https://gist.githubusercontent.com/DennisOSRM/3728987/raw/052251fcdc23602770f6c543be9b3e12f0cac50a/Jamroot.diff"
    sha1 "5e7660e00e4189e42b8d79fbd2d6da21feb2259b"
  end

  # apply upstream commit to enable building with clang
  patch do
    url "https://github.com/luabind/luabind/commit/3044a9053ac50977684a75c4af42b2bddb853fad.diff"
    sha1 "49ecf2060a691abcdf4b3e07f1de450a2858f14f"
  end

  # include C header that is not pulled in automatically on OS X 10.9 anymore
  # submitted https://github.com/luabind/luabind/pull/20
  patch do
    url "https://gist.githubusercontent.com/DennisOSRM/a246514bf7d01631dda8/raw/0e83503dbf862ebfb6ac063338a6d7bca793f94d/object_rep.diff"
    sha1 "482693598edcde3d4c04fef3dfa35ea23f8e6bb4"
  end if MacOS.version >= :mavericks

  def install
    ENV["LUA_PATH"] = Formula["lua51"].opt_prefix
    args = [
      "release",
      "install",
    ]
    if ENV.compiler == :clang
      args << "--toolset=clang"
    elsif ENV.compiler == :llvm
      args << "--toolset=llvm"
    elsif ENV.compiler == :gcc
      args << "--toolset=darwin"
    end
    args << "--prefix=#{prefix}"
    system "bjam", *args
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
