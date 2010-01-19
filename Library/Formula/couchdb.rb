require 'formula'

class Couchdb <Formula
  @url='http://apache.abdaal.com/couchdb/0.10.1/apache-couchdb-0.10.1.tar.gz'
  @homepage='http://couchdb.apache.org/'
  @md5='a34dae8bf402299e378d7e8c13b7ba46'

  depends_on 'spidermonkey'
  depends_on 'icu4c'
  depends_on 'erlang'

  def patches; DATA end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}"
    system "make"
    system "make install"

    (prefix+"lib/couchdb/bin/couchjs").chmod 0755
    (var+'lib'+'couchdb').mkpath
    (var+'log'+'couchdb').mkpath
  end
end


# this patch because couchdb doesn't try to find where spidermonkey or erlang
# are installed it just adds a bunch of paths and hopes for the best. However
# for users who install Homebrew somewhere that is non standard, this breaks
__END__
diff --git a/configure b/configure
index edb6438..472cd2c 100755
--- a/configure
+++ b/configure
@@ -11240,10 +11240,7 @@ if test "${with_erlang+set}" = set; then :
 
 else
 
-    ERLANG_FLAGS="-I${libdir}/erlang/usr/include"
-    ERLANG_FLAGS="$ERLANG_FLAGS -I/usr/lib/erlang/usr/include"
-    ERLANG_FLAGS="$ERLANG_FLAGS -I/usr/local/lib/erlang/usr/include"
-    ERLANG_FLAGS="$ERLANG_FLAGS -I/opt/local/lib/erlang/usr/include"
+    ERLANG_FLAGS="-I$(dirname $(dirname $(which erl)))/lib/erlang/usr/include"
 
 fi
 
@@ -11257,13 +11257,7 @@ if test "${with_js_include+set}" = set; then :
 
 else
 
-    JS_FLAGS="-I/usr/include"
-    JS_FLAGS="$JS_FLAGS -I/usr/include/js"
-    JS_FLAGS="$JS_FLAGS -I/usr/include/mozjs"
-    JS_FLAGS="$JS_FLAGS -I/usr/local/include"
-    JS_FLAGS="$JS_FLAGS -I/opt/local/include"
-    JS_FLAGS="$JS_FLAGS -I/usr/local/include/js"
-    JS_FLAGS="$JS_FLAGS -I/opt/local/include/js"
+    JS_FLAGS="-I`js-config --includedir`/js"
 
 fi
 
