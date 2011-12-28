require 'formula'

class Pcb < Formula
  url 'http://downloads.sourceforge.net/project/pcb/pcb/pcb-20110918/pcb-20110918.tar.gz'
  homepage 'http://pcb.gpleda.org/'
  md5 '54bbc997eeb22b85cf21fed54cb8e181'
  version '20110908'
  head 'git://git.gpleda.org/pcb.git'

  depends_on 'pkg-config' => :build
  depends_on 'intltool'
  depends_on 'gettext'
  depends_on 'd-bus'
  depends_on 'gd'
  depends_on 'glib'
  depends_on 'gtkglext'
  depends_on 'XML::Parser' => :perl

  def patches
    [ DATA ]
  end

  def install
    ENV.x11
    ENV.append 'ACLOCAL_FLAGS', "-I#{HOMEBREW_PREFIX}/share/aclocal"

    system "./autogen.sh" if ARGV.build_head?

    configure_options = [ "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-update-desktop-database",
                          "--disable-update-mime-database" ]

    system "./configure", *configure_options

    system "make"
    system "make install"
  end
end

# There's a missing define from GLU. Defining this fixes everything up
__END__
diff --git a/src/hid/common/hidgl.c b/src/hid/common/hidgl.c
index 15273a6..ff73ca7 100644
--- a/src/hid/common/hidgl.c
+++ b/src/hid/common/hidgl.c
@@ -66,6 +66,7 @@
 #include <dmalloc.h>
 #endif
 
+typedef GLvoid (*_GLUfuncptr)(GLvoid);
 
 triangle_buffer buffer;
 float global_depth = 0;

