require 'formula'

class Pcb < Formula
  url 'wget http://downloads.sourceforge.net/project/pcb/pcb/pcb-20110918/pcb-20110918.tar.gz'
  homepage 'http://pcb.gpleda.org/'
  sha1 '53ca27797d4db65a068b56f157e3ea6c5c29051f'

  depends_on 'gtk+'
  depends_on 'gd'
  depends_on 'gettext'
  depends_on 'd-bus'
  depends_on 'intltool'
  depends_on 'gtkglext'

  def patches; DATA; end

  def install
    # Help configure find libraries
    ENV.x11
    ENV.gcc_4_2

    gettext = Formula.factory('gettext')

    args = ["--disable-update-desktop-database",
            "--disable-update-mime-database",
            "--prefix=#{prefix}",
            "--with-gettext=#{gettext.prefix}",
            "--enable-dbus"]

    system "./configure", *args
    system "make"
    system "make install"
  end

  def caveats
    "This software runs under X11."
  end
end

__END__
diff --git a/src/hid/common/hidgl.c b/src/hid/common/hidgl.c
index 21edb5d..7101bef 100644
--- a/src/hid/common/hidgl.c
+++ b/src/hid/common/hidgl.c
@@ -66,6 +66,8 @@
 #include <dmalloc.h>
 #endif
 
+// compatibility typedef
+typedef GLvoid (*_GLUfuncptr)();
 
 triangle_buffer buffer;
 float global_depth = 0;
