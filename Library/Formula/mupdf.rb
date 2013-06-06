require 'formula'

class NeedsSnowLeopard < Requirement
  fatal true

  satisfy MacOS.version >= :snow_leopard

  def message; <<-EOS.undent
    The version of Freetype that comes with Leopard is too old to build MuPDF
    against. It is possible to get MuPDF working on Leopard using the Freetype
    formula from Homebrew-Dupes and some tweaks to the Makefile.

    Doing so is left as an exercise for the reader.
    EOS
  end
end

class Mupdf < Formula
  homepage 'http://mupdf.com'
  url 'https://mupdf.googlecode.com/files/mupdf-1.2-source.zip'
  sha1 'd521382b80b3d1f7b8ad6e00ceb91721aa5e1917'

  depends_on NeedsSnowLeopard

  depends_on 'jpeg'
  depends_on 'openjpeg'
  depends_on 'jbig2dec'
  depends_on :x11 # libpng, freetype and the X11 libs

  def patches
    # Fix up the Makefile so it doesn't mess with our CFLAGS.
    DATA
  end

  def install
    openjpeg = Formula.factory 'openjpeg'
    ENV.append 'CPPFLAGS', "-I#{Dir[openjpeg.include/'openjpeg-*'].first}"
    ENV.append 'CFLAGS', '-DNDEBUG'
    ENV['SYS_FREETYPE_INC'] = "-I#{MacOS::X11.include}/freetype2"

    system "make", "install", "prefix=#{prefix}"
  end
end

__END__

Remove some Makefile rules that Homebrew takes care of through CFLAGS and
LDFLAGS. MuPDF doesn't look at CPPFLAGS, so we piggyback it onto CFLAGS.

diff --git a/Makerules b/Makerules
index 3e036f6..c9ddc69 100644
--- a/Makerules
+++ b/Makerules
@@ -5,24 +5,6 @@ OS := $(OS:MINGW%=MINGW)
 
 CFLAGS += -Wall
 
-ifeq "$(build)" "debug"
-CFLAGS += -pipe -g -DDEBUG
-else ifeq "$(build)" "profile"
-CFLAGS += -pipe -O2 -DNDEBUG -pg
-LDFLAGS += -pg
-else ifeq "$(build)" "release"
-CFLAGS += -pipe -O2 -DNDEBUG -fomit-frame-pointer
-else ifeq "$(build)" "coverage"
-CFLAGS += -pipe -g -DDEBUG -pg -fprofile-arcs -ftest-coverage
-LIBS += -lgcov
-else ifeq "$(build)" "native"
-CFLAGS += -pipe -O2 -DNDEBUG -fomit-frame-pointer -march=native -mfpmath=sse
-else ifeq "$(build)" "memento"
-CFLAGS += -pipe -g -DMEMENTO -DDEBUG
-else
-$(error unknown build setting: '$(build)')
-endif
-
 ifeq "$(OS)" "Linux"
 SYS_FREETYPE_INC := `pkg-config --cflags freetype2`
 X11_LIBS := -lX11 -lXext
@@ -36,18 +18,9 @@ endif
 
 # Mac OS X build depends on some thirdparty libs
 ifeq "$(OS)" "Darwin"
-SYS_FREETYPE_INC := -I/usr/X11R6/include/freetype2
-CFLAGS += -I/usr/X11R6/include
-LDFLAGS += -L/usr/X11R6/lib
+CFLAGS += $(CPPFLAGS)
 RANLIB_CMD = ranlib $@
 X11_LIBS := -lX11 -lXext
-ifeq "$(arch)" "amd64"
-CFLAGS += -m64
-LDFLAGS += -m64
-else
-CFLAGS += -m32
-LDFLAGS += -m32
-endif
 endif
 
 # The following section is an example of how to simply do cross-compilation
