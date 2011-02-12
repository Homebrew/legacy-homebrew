require 'formula'

class Feh <Formula
  url 'http://feh.finalrewind.org/feh-1.11.2.tar.bz2'
  homepage 'http://freshmeat.net/projects/feh'
  md5 '3b2354d78a882ce02b429bbe053467a2'

  depends_on 'giblib' => :build
  depends_on 'libpng' => :build

  def patches
    DATA
  end

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end
end

__END__
Patch to add X11 library path.

diff --git a/config.mk b/config.mk
index 6a5b8b3..e301ff1 100644
--- a/config.mk
+++ b/config.mk
@@ -31,3 +31,4 @@ CFLAGS += ${xinerama} -DPREFIX=\"${PREFIX}\" \
        -DPACKAGE=\"${PACKAGE}\" -DVERSION=\"${VERSION}\"
 
 LDLIBS += -lm -lpng -lX11 -lImlib2 -lgiblib ${xinerama_ld}
+LDFLAGS += -L/usr/X11/lib
