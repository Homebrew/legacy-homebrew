require 'formula'

class Cutter < Formula
  homepage 'http://cutter.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/cutter/cutter/1.2.0/cutter-1.2.0.tar.gz'
  md5 '509963983083be65e729ea646f3f8360'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'intltool'
  depends_on 'gettext'

  def patches
    # see https://github.com/mxcl/homebrew/pull/11163#issuecomment-4689357
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}",
           "--disable-glibtest", "--disable-goffice",
           "--disable-gstreamer", "--disable-libsoup"
    system "make"
    system "make install"
  end
end

__END__
--- a/cppcutter/cppcut-assertions-helper.h	2011-12-31 02:02:52.000000000 -0800
+++ b/cppcutter/cppcut-assertions-helper.h	2012-03-25 23:57:16.000000000 -0700
@@ -54,24 +54,6 @@
                       const char *expression_expected,
                       const char *expression_actual);
 
-    template <class Type> void assert_equal(const Type *expected,
-                                            const Type *actual,
-                                            const char *expression_expected,
-                                            const char *expression_actual)
-    {
-        assert_equal_reference(expected, actual,
-                               expression_expected, expression_actual);
-    };
-
-    template <class Type> void assert_equal(const Type& expected,
-                                            const Type& actual,
-                                            const char *expression_expected,
-                                            const char *expression_actual)
-    {
-        assert_equal_reference(expected, actual,
-                               expression_expected, expression_actual);
-    };
-
     template <class Type> void assert_equal_reference(
         const Type& expected, const Type& actual,
         const char *expression_expected, const char *expression_actual)
@@ -95,6 +77,24 @@
         }
     }
 
+    template <class Type> void assert_equal(const Type *expected,
+                                            const Type *actual,
+                                            const char *expression_expected,
+                                            const char *expression_actual)
+    {
+        assert_equal_reference(expected, actual,
+                               expression_expected, expression_actual);
+    };
+
+    template <class Type> void assert_equal(const Type& expected,
+                                            const Type& actual,
+                                            const char *expression_expected,
+                                            const char *expression_actual)
+    {
+        assert_equal_reference(expected, actual,
+                               expression_expected, expression_actual);
+    };
+
     CPPCUT_DECL
     void assert_not_equal(char *expected, char *actual,
                           const char *expression_expected,
