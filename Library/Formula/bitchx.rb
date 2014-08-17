require "formula"

class Bitchx < Formula

  homepage "https://github.com/BitchX"
  url "http://bitchx.ca/BitchX-1.2-final.tar.gz"
  mirror "http://pkgs.fedoraproject.org/repo/pkgs/BitchX/BitchX-1.2-final.tar.gz/5c4947f5a345574e28d93f78cb191ce4/BitchX-1.2-final.tar.gz"
  sha1 "a2162a18d3a96ade7d2410f6a560e43f7d6b8763"

  # Reported upstream:
  # https://github.com/BitchX/BitchX/pull/8
  patch :DATA

  def install
    args = %W{
      --prefix=#{prefix}
      --with-ssl
      --with-plugins
      --enable-ipv6
      --mandir=#{man}
    }

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    On case-sensitive filesytems, it is necessary to run `BitchX` not `bitchx`.
    For best visual appearance, your terminal emulator may need:
    * Character encoding set to Western (ISO Latin 1).
      (or a similar, compatible encoding)
    * A font capable of extended ASCII characters:
      See: https://www.google.com/search?q=perfect+dos+vga+437
    EOS
  end

  test do
    system bin/"BitchX", "-v"
  end

end

__END__
diff --git a/source/compat.c b/source/compat.c
index fa68988..9549bd6 100644
--- a/source/compat.c
+++ b/source/compat.c
@@ -1011,6 +1011,10 @@ int  scandir (const char *name,
 #include <stddef.h>
 #include <string.h>

+#if defined(__APPLE__)
+ #define environ (*_NSGetEnviron())
+#endif
+
 int   bsd_setenv(const char *name, const char *value, int rewrite);

 /*
