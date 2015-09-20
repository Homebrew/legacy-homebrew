class Gtksourceview3 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/3.18/gtksourceview-3.18.0.tar.xz"
  sha256 "54b111264e6985e26a878dec88ff94fd0a9ae0dc4cfcdf08f4a6b5f655d4b693"

  bottle do
    sha256 "809a9a7c643c4740bd2c1c746496bce955b2611c2ec593df2f3b8856bd4099d7" => :el_capitan
    sha256 "1691cfa374f3bfe0d443cc5fddb038d5d11446f9b8d63b89e90043d253a57940" => :yosemite
    sha256 "0d103d508a33ca16ce22f13faa6c5c8648a7c714f6b1eba5a4d16a9a58168dd8" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+3"

  # reported upstream as https://bugzilla.gnome.org/show_bug.cgi?id=755308
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gtksourceview/gtksourceview.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    EOS
    ENV.libxml2
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx3 = Formula["gtk+3"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{include}/gtksourceview-3.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lgtksourceview-3.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/configure b/configure
index ad97334..9faade8 100755
--- a/configure
+++ b/configure
@@ -12636,76 +12636,6 @@ fi



-for flag in          -Wl,--no-as-needed              ; do
-  as_CACHEVAR=`$as_echo "ax_cv_check_cflags_$ax_compiler_flags_test_$flag" | $as_tr_sh`
-{ $as_echo "$as_me:${as_lineno-$LINENO}: checking whether C compiler accepts $flag" >&5
-$as_echo_n "checking whether C compiler accepts $flag... " >&6; }
-if eval \${$as_CACHEVAR+:} false; then :
-  $as_echo_n "(cached) " >&6
-else
-
-  ax_check_save_flags=$CFLAGS
-  CFLAGS="$CFLAGS $ax_compiler_flags_test $flag"
-  cat confdefs.h - <<_ACEOF >conftest.$ac_ext
-/* end confdefs.h.  */
-
-int
-main ()
-{
-
-  ;
-  return 0;
-}
-_ACEOF
-if ac_fn_c_try_compile "$LINENO"; then :
-  eval "$as_CACHEVAR=yes"
-else
-  eval "$as_CACHEVAR=no"
-fi
-rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
-  CFLAGS=$ax_check_save_flags
-fi
-eval ac_res=\$$as_CACHEVAR
-	       { $as_echo "$as_me:${as_lineno-$LINENO}: result: $ac_res" >&5
-$as_echo "$ac_res" >&6; }
-if eval test \"x\$"$as_CACHEVAR"\" = x"yes"; then :
-
-if ${WARN_LDFLAGS+:} false; then :
-
-  case " $WARN_LDFLAGS " in #(
-  *" $flag "*) :
-    { { $as_echo "$as_me:${as_lineno-$LINENO}: : WARN_LDFLAGS already contains \$flag"; } >&5
-  (: WARN_LDFLAGS already contains $flag) 2>&5
-  ac_status=$?
-  $as_echo "$as_me:${as_lineno-$LINENO}: \$? = $ac_status" >&5
-  test $ac_status = 0; } ;; #(
-  *) :
-
-     as_fn_append WARN_LDFLAGS " $flag"
-     { { $as_echo "$as_me:${as_lineno-$LINENO}: : WARN_LDFLAGS=\"\$WARN_LDFLAGS\""; } >&5
-  (: WARN_LDFLAGS="$WARN_LDFLAGS") 2>&5
-  ac_status=$?
-  $as_echo "$as_me:${as_lineno-$LINENO}: \$? = $ac_status" >&5
-  test $ac_status = 0; }
-     ;;
-esac
-
-else
-
-  WARN_LDFLAGS=$flag
-  { { $as_echo "$as_me:${as_lineno-$LINENO}: : WARN_LDFLAGS=\"\$WARN_LDFLAGS\""; } >&5
-  (: WARN_LDFLAGS="$WARN_LDFLAGS") 2>&5
-  ac_status=$?
-  $as_echo "$as_me:${as_lineno-$LINENO}: \$? = $ac_status" >&5
-  test $ac_status = 0; }
-
-fi
-
-else
-  :
-fi
-
-done


     if test "$ax_enable_compile_warnings" != "no"; then :
