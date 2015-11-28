class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/0.14/gssdp-0.14.12.tar.xz"
  sha256 "ad4b6cf1c2cfbe35dd369ca30f197a2c12a9a443feebe1eabee06e88c7e6ef1f"

  bottle do
    cellar :any
    sha256 "f0346d2cdac6d5e2a2fc40b282426582c09e177c6d7202961cd51522bf680551" => :yosemite
    sha256 "b0554ba681354f342915e358ce628a06164b1984ee9486b6fcb56b78f26efc55" => :mavericks
    sha256 "f598056ff1d988ee2f96b3f8bd34e83fc23418e1880b85bd215766de20029262" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"

  # reported upstream in https://bugzilla.gnome.org/show_bug.cgi?id=750981
  # fix is known and should be included in the next release
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libgssdp/gssdp.h>

      int main(int argc, char *argv[]) {
        GType type = gssdp_client_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gssdp-1.0
      -D_REENTRANT
      -L#{lib}
      -lgssdp-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/configure b/configure
index 179dbcf..a936f6b 100755
--- a/configure
+++ b/configure
@@ -6146,78 +6146,6 @@ fi
 
 
 
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
-
-
     if test "$ax_enable_compile_warnings" != "no"; then :
 
         # "yes" flags

