require 'formula'

class NeedsSnowLeopard < Requirement
  def satisfied?
    MacOS.version >= :snow_leopard
  end

  def fatal?
    true
  end

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
  url 'http://mupdf.googlecode.com/files/mupdf-1.0-source.tar.gz'
  sha1 'c5c4496836cdd4bdf7b2d2344ec045c9508e49e4'

  depends_on NeedsSnowLeopard.new

  depends_on 'jpeg'
  depends_on 'openjpeg'
  depends_on 'jbig2dec'
  depends_on :x11 # libpng, freetype

  def patches
    # Fix up the Makefile so it doesn't mess with our CFLAGS.
    DATA
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end

__END__

Remove some Makefile rules that Homebrew takes care of through CFLAGS and
LDFLAGS. MuPDF doesn't look at CPPFLAGS, so we piggyback it onto CFLAGS.

diff --git a/Makerules b/Makerules
index 26eab3c..46e8dc9 100644
--- a/Makerules
+++ b/Makerules
@@ -5,21 +5,6 @@ OS := $(OS:MINGW%=MINGW)
 
 CFLAGS += -Wall
 
-ifeq "$(build)" "debug"
-CFLAGS += -pipe -g -DDEBUG
-else ifeq "$(build)" "profile"
-CFLAGS += -pipe -O2 -DNDEBUG -pg
-LDFLAGS += -pg
-else ifeq "$(build)" "release"
-CFLAGS += -pipe -O2 -DNDEBUG -fomit-frame-pointer
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
@@ -34,17 +19,9 @@ endif
 # Mac OS X build depends on some thirdparty libs
 ifeq "$(OS)" "Darwin"
 SYS_FREETYPE_INC := -I/usr/X11R6/include/freetype2
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
