class Luajit < Formula
  desc "Just-In-Time Compiler (JIT) for the Lua programming language"
  homepage "http://luajit.org/luajit.html"
  url "http://luajit.org/download/LuaJIT-2.0.4.tar.gz"
  sha256 "620fa4eb12375021bef6e4f237cbd2dd5d49e56beb414bee052c746beef1807d"
  head "http://luajit.org/git/luajit-2.0.git"

  devel do
    url "http://luajit.org/git/luajit-2.0.git", :branch => "v2.1"
    version "2.1"
  end

  bottle do
    sha256 "13b55554d8a6772cec7eb3ba04c484146dc705417591c9455108aa2f9950dd56" => :yosemite
    sha256 "f3ab35cf3d35a68037f65353ebe6a6e09dc9e021d29e4067c03f90e0805a0acd" => :mavericks
    sha256 "0d50380c98eef0fcc4be1d91d11d0cd1a6afefa600833f1cfce502336228e36c" => :mountain_lion
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
