require "formula"

class Hatari < Formula
  homepage "http://hatari.tuxfamily.org"
  head "http://hg.tuxfamily.org/mercurialroot/hatari/hatari", :using => :hg, :branch => "default"
  url "http://download.tuxfamily.org/hatari/1.8.0/hatari-1.8.0.tar.bz2"
  sha1 "08d950c3156c764b87ac0ae03c4f350febff9567"

  depends_on :x11
  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "sdl"

  def install
    sdl = Formula["sdl"].opt_prefix
    system "cmake", "-DENABLE_OSX_BUNDLE:BOOL=0",
                    "-DSDLMAIN_LIBRARY:FILEPATH=#{sdl}/lib/libSDLmain.a",
                    "-DSDL_INCLUDE_DIR:PATH=#{sdl}/include/SDL",
                    "-DSDL_LIBRARY:STRING=#{sdl}/lib/libSDLmain.a;#{sdl}/lib/libSDL.dylib;-framework Cocoa",
                    *std_cmake_args

    system "make", "install"
  end
end
