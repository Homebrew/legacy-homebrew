require "formula"

class Pcb < Formula
  homepage "http://pcb.geda-project.org/"
  head "git://git.geda-project.org/pcb.git"
  url "https://downloads.sourceforge.net/project/pcb/pcb/pcb-20140316/pcb-20140316.tar.gz"
  sha1 "ec714ff136d1817e500e1a9e654e786883b9501e"

  option "with-doc", "Build the documentation (requires LaTeX)."

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "d-bus"
  depends_on "gtk+"
  depends_on "gd"
  depends_on "glib"
  depends_on "gtkglext"
  depends_on :x11
  depends_on :tex if build.with? "doc"

  conflicts_with "gts", :because => "both install `include/gts.h`"

  patch :DATA

  def install
    system "./autogen.sh" if build.head?
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--disable-update-desktop-database",
            "--disable-update-mime-database"]
    args << "--disable-doc" if build.without? "doc"

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end

# There's a missing define from GLU. Defining this fixes everything up.
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

