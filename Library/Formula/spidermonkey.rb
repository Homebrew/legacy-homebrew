require 'brewkit'

class Spidermonkey <Formula  
  @url="http://ftp.mozilla.org/pub/mozilla.org/js/js-1.7.0.tar.gz"
  @homepage='https://developer.mozilla.org/en/SpiderMonkey'
  @md5='5571134c3863686b623ebe4e6b1f6fe6'

  def deps
    # You can build Python without readline, but you really don't want to.
    LibraryDep.new 'readline'
    LibraryDep.new 'nspr'
  end

  def patches
    DATA
  end

  def install
    ENV.j1
    Dir.chdir "src" do
      system "make JS_DIST=#{HOMEBREW_PREFIX} JS_THREADSAFE=1 DEFINES=-DJS_C_STRINGS_ARE_UTF8 -f Makefile.ref"
      system "make JS_DIST=#{prefix} -f Makefile.ref export"
      system "ranlib #{prefix}/lib/libjs.a"
    end
  end
end


__END__
--- a/src/jsprf.c	2009-07-26 12:32:01.000000000 -0700
+++ b/src/jsprf.c	2009-07-26 12:33:12.000000000 -0700
@@ -58,6 +58,8 @@
 */
 #ifdef HAVE_VA_COPY
 #define VARARGS_ASSIGN(foo, bar)        VA_COPY(foo,bar)
+#elif defined(va_copy)
+#define VARARGS_ASSIGN(foo, bar)        va_copy(foo,bar)
 #elif defined(HAVE_VA_LIST_AS_ARRAY)
 #define VARARGS_ASSIGN(foo, bar)        foo[0] = bar[0]
 #else
