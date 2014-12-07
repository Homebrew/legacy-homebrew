require 'formula'

class Ume < Formula
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0156.tar.gz"
  sha1 "9cda662385c0b168ca564dab0fb1e839065f6a01"
  version "0.156"

  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha1 "9850cfef7179c418ce1104edcdcfc0682f7979b3" => :yosemite
    sha1 "2afbdf96a4c6f45b04ada32debfdb86ef08aa2d2" => :mavericks
    sha1 "4e4684c5682424c294bc76d3ff12d9cdf3cdca88" => :mountain_lion
  end

  depends_on 'sdl2'

  # Fix for Cocoa framework linking and sdl-config path
  # It's been upstreamed, so remove from the next release
  # https://github.com/mamedev/mame/pull/60
  patch :DATA

  def install
    ENV['MACOSX_USE_LIBSDL'] = '1'
    ENV['PTR64'] = (MacOS.prefer_64_bit? ? '1' : '0')

    system "make", "CC=#{ENV.cc}", "LD=#{ENV.cxx}", "TARGET=ume"

    if MacOS.prefer_64_bit?
      bin.install 'ume64' => 'ume'
    else
      bin.install 'ume'
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
