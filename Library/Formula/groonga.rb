require 'formula'

class Groonga < Formula
  homepage 'http://groonga.org/'
  url 'http://packages.groonga.org/source/groonga/groonga-2.0.4.tar.gz'
  sha1 '1000fd087a382da7e7e5f8679fbaa3b61b3e954e'

  depends_on 'msgpack'

  # Patches are upstream and should be removed in the next release. See:
  # https://github.com/groonga/groonga/commit/690db3c1610cba7c8e4225a64ded72a1fe90053a
  # https://github.com/groonga/groonga/commit/26ec2251c28dda151c66f4a530f2330d009edb32
  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-zlib"
    system "make install"
  end
end

__END__
diff --git a/src/nginx-module/config b/src/nginx-module/config
index a25a377..7eafdf7 100644
--- a/src/nginx-module/config
+++ b/src/nginx-module/config
@@ -6,7 +6,7 @@ groonga_strip_switch()

 if [ "$GROONGA_HTTPD_IN_TREE" = yes ]; then
   groonga_cflags="${GROONGA_HTTPD_CFLAGS} -I ${GROONGA_HTTPD_IN_TREE_INCLUDE_PATH}"
-  groonga_libs="-L ${GROONGA_HTTPD_IN_TREE_LINK_PATH} ${GROONGA_HTTPD_LIBS} -Wl,-rpath=${GROONGA_HTTPD_RPATH}"
+  groonga_libs="-L${GROONGA_HTTPD_IN_TREE_LINK_PATH} ${GROONGA_HTTPD_LIBS} -Wl,-rpath -Wl,${GROONGA_HTTPD_RPATH}"

   ngx_addon_name=ngx_http_groonga_module
   HTTP_MODULES="$HTTP_MODULES ngx_http_groonga_module"
