require 'formula'

class Mess < Formula
  homepage "http://www.mess.org/"
  url "https://github.com/mamedev/mame/archive/mame0156.tar.gz"
  sha1 "9cda662385c0b168ca564dab0fb1e839065f6a01"
  version "0.156"

  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha1 "e5a44194f5e7498ef816530ec8196c1f96448f96" => :yosemite
    sha1 "6003ef6faaced6b86a8f63ab7a2ec33885c2fa75" => :mavericks
    sha1 "51c9c19ba6dfc316986406018da7a4f86c46dd1d" => :mountain_lion
  end

  depends_on 'sdl2'

  # Fix for Cocoa framework linking and sdl-config path
  # It's been upstreamed, so remove from the next release
  # https://github.com/mamedev/mame/pull/60
  patch :DATA

  def install
    ENV['MACOSX_USE_LIBSDL'] = '1'
    ENV['PTR64'] = (MacOS.prefer_64_bit? ? '1' : '0')

    system "make", "CC=#{ENV.cc}", "LD=#{ENV.cxx}",
                   "TARGET=mess", "SUBTARGET=mess"

    if MacOS.prefer_64_bit?
      bin.install 'mess64' => 'mess'
    else
      bin.install 'mess'
    end
  end
end

__END__
diff --git a/src/osd/sdl/sdl.mak b/src/osd/sdl/sdl.mak
index 21dd814..eaec664 100644
--- a/src/osd/sdl/sdl.mak
+++ b/src/osd/sdl/sdl.mak
@@ -507,8 +507,8 @@ else
 # files (header files are #include "SDL/something.h", so the extra "/SDL"
 # causes a significant problem)
-INCPATH += `sdl-config --cflags | sed 's:/SDL::'`
+INCPATH += `$(SDL_CONFIG) --cflags | sed 's:/SDL::'`
 CCOMFLAGS += -DNO_SDL_GLEXT
 # Remove libSDLmain, as its symbols conflict with SDLMain_tmpl.m
-LIBS += `sdl-config --libs | sed 's/-lSDLmain//'` -lpthread -framework OpenGL
+LIBS += `$(SDL_CONFIG) --libs | sed 's/-lSDLmain//'` -lpthread -framework Cocoa -framework OpenGL
 DEFS += -DMACOSX_USE_LIBSDL
 endif   # MACOSX_USE_LIBSDL
