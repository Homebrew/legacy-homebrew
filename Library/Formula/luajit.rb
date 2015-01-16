require "formula"

class Luajit < Formula
  homepage "http://luajit.org/luajit.html"
  url "http://luajit.org/download/LuaJIT-2.0.3.tar.gz"
  sha1 "2db39e7d1264918c2266b0436c313fbd12da4ceb"
  head "http://luajit.org/git/luajit-2.0.git"
  revision 1

  devel do
    url "http://luajit.org/git/luajit-2.0.git", :branch => "v2.1"
    version "2.1"
  end

  bottle do
    sha1 "9a6fc01ed0659ecc07a1e34daecdcf82cd150ca4" => :yosemite
    sha1 "7ed3346a644ca5cd73c51131c54060b13038208e" => :mavericks
    sha1 "0363e0a9c7ff2580d35363622b228fba7bb8f770" => :mountain_lion
  end

  skip_clean "lib/lua/5.1", "share/lua/5.1"

  deprecated_option "enable-debug" => "with-debug"

  option "with-debug", "Build with debugging symbols"
  option "with-52compat", "Build with additional Lua 5.2 compatibility"

  def install
    # 1 - Override the hardcoded gcc.
    # 2 - Remove the "-march=i686" so we can set the march in cflags.
    # Both changes should persist and were discussed upstream.
    inreplace "src/Makefile" do |f|
      f.change_make_var! "CC", ENV.cc
      f.change_make_var! "CCOPT_x86", ""
    end

    ENV.O2 # Respect the developer's choice.

    args = %W[PREFIX=#{prefix}]

    # This doesn't yet work under superenv because it removes "-g"
    args << "CCDEBUG=-g" if build.with? "debug"

    # The development branch of LuaJIT normally does not install "luajit".
    args << "INSTALL_TNAME=luajit" if build.devel?

    args << "XCFLAGS=-DLUAJIT_ENABLE_LUA52COMPAT" if build.with? "52compat"

    system "make", "amalg", *args
    system "make", "install", *args
    # Having an empty Lua dir in Lib can screw with the new Lua setup.
    rm_rf prefix/"lib/lua"
    rm_rf prefix/"share/lua"
  end

  test do
    system "#{bin}/luajit", "-e", <<-EOS.undent
      local ffi = require("ffi")
      ffi.cdef("int printf(const char *fmt, ...);")
      ffi.C.printf("Hello %s!\\n", "#{ENV["USER"]}")
    EOS
  end
end
