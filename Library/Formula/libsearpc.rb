class Libsearpc < Formula
  desc "A simple and easy-to-use C language RPC framework"
  homepage "http://www.seafile.com/"
  url "https://github.com/haiwen/libsearpc/archive/v3.0-latest.tar.gz"
  version "3.0"
  sha256 "56313771e0ad7dc075c4590b6a75daeb3939937b21716d82c91be2612133b8cd"

  head "https://github.com/haiwen/libsearpc.git"

  # FIX for homebrew autotools path
  patch :DATA

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "jansson"
  depends_on "glib"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--disable-compile-demo"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <searpc.h>
      #include <stdio.h>
      char *printer(void *arg, const gchar *fcall_str, size_t fcall_len,
                    size_t *ret_len) {
        fprintf(stdout, "%s", fcall_str);
        *ret_len = 0;
        return NULL;
      }

      int main() {
        SearpcClient *client = searpc_client_new();
        client->send = printer;
        searpc_client_call__int(client, "test", NULL, 0, NULL);
        searpc_client_free(client);
        return 0;
      }
    EOS
    args = "-I#{HOMEBREW_PREFIX}/include/glib-2.0 -I#{Formula["glib"].opt_prefix}/lib/glib-2.0/include -I#{Formula["gettext"].opt_prefix}/include -I#{include} -L#{lib} -lsearpc -lglib-2.0 -L#{Formula["gettext"].opt_prefix}/lib -lintl -ljansson".split
    args += %w[test.c -o test]
    system ENV.cc, *args
    system "./test"
  end
end

__END__
diff --git a/autogen.sh b/autogen.sh
index b6a7d24..af0d8d7 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -60,7 +60,7 @@ fi
 if test x"$MSYSTEM" = x"MINGW32"; then
     autoreconf --install -I/local/share/aclocal
 elif test "$(uname -s)" = "Darwin"; then
-    autoreconf --install -I/opt/local/share/aclocal
+    autoreconf --install -I/usr/local/share/aclocal
 else
     autoreconf --install
 fi
