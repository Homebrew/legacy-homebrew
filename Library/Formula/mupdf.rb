require 'formula'

class NeedsSnowLeopard < Requirement
  def satisfied?
    MACOS_VERSION >= 10.6
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
  url 'http://mupdf.googlecode.com/files/mupdf-0.9-source.tar.gz'
  md5 '76640ee16a797a27fe49cc0eaa87ce3a'

  depends_on NeedsSnowLeopard.new

  depends_on 'jpeg'
  depends_on 'openjpeg'
  depends_on 'jbig2dec'

  def patches
    # Fix up the Makefile so it doesn't mess with our CFLAGS.
    DATA
  end

  def install
    ENV.x11 # For LibPNG and Freetype
    system "make", "install", "prefix=#{prefix}"

    # MuPDF comes with some handy command-line tools. However, their names can
    # clash with other tools installed by formulae such as Poppler. So, we
    # add a `mu` prefix to every binary that starts with `pdf`.
    bin.entries.select{ |b| b.basename.to_s.match /^pdf/ }.each do |p|
      mv bin + p, bin + ('mu' + p.basename.to_s)
    end
  end

  def caveats; <<-EOS.undent
    All MuPDF command line tools have been prefixed with `mu` to prevent name
    clashes with other PDF packages.
    EOS
  end
end

__END__

Remove some Makefile rules that Homebrew takes care of through CFLAGS and
LDFLAGS. MuPDF doesn't look at CPPFLAGS, so we piggyback it onto CFLAGS.

diff --git a/Makerules b/Makerules
index 63a75d6..077fcf5 100644
--- a/Makerules
+++ b/Makerules
@@ -5,19 +5,6 @@ OS := $(OS:MINGW%=MINGW)
 
 CFLAGS += -Wall
 
-ifeq "$(build)" "debug"
-CFLAGS += -pipe -g
-else ifeq "$(build)" "profile"
-CFLAGS += -pipe -O2 -DNDEBUG -pg
-LDFLAGS += -pg
-else ifeq "$(build)" "release"
-CFLAGS += -pipe -O2 -DNDEBUG -fomit-frame-pointer
-else ifeq "$(build)" "native"
-CFLAGS += -pipe -O2 -DNDEBUG -fomit-frame-pointer -march=native -mfpmath=sse
-else
-$(error unknown build setting: '$(build)')
-endif
-
 ifeq "$(OS)" "Linux"
 SYS_FREETYPE_INC := `pkg-config --cflags freetype2`
 X11_LIBS := -lX11 -lXext
@@ -32,16 +19,8 @@ endif
 # Mac OS X build depends on some thirdparty libs
 ifeq "$(OS)" "Darwin"
 SYS_FREETYPE_INC := -I/usr/X11R6/include/freetype2
-CFLAGS += -I/usr/X11R6/include
-LDFLAGS += -L/usr/X11R6/lib
+CFLAGS += $(CPPFLAGS)
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
