require 'formula'

class Rdesktop < Formula
  homepage 'http://www.rdesktop.org/'
  url 'http://downloads.sourceforge.net/project/rdesktop/rdesktop/1.8.0/rdesktop-1.8.0.tar.gz'
  sha1 '2d39a41d29ad1ad2509d1e343a2817a3c7d666de'

  depends_on :x11

  def patches
    DATA
  end

  def install
    args = ["--prefix=#{prefix}",
            "--disable-credssp",
            "--disable-smartcard", # disable temporally before upstream fix
            "--with-openssl=#{MacOS.sdk_path}/usr",
            "--x-includes=#{MacOS::X11.include}"]
    system "./configure", *args
    system "make install"
  end
end

__END__
diff --git a/tcp.c b/tcp.c
index a541e45..943a655 100644
--- a/tcp.c
+++ b/tcp.c
@@ -193,7 +193,7 @@ tcp_recv(STREAM s, uint32 length)
 	int rcvd = 0, ssl_err;
 
 	if (g_network_error == True)
-		return;
+		return NULL;
 
 	if (s == NULL)
 	{
@@ -318,7 +318,9 @@ tcp_tls_connect(void)
 		}
 
 		options = 0;
+#ifdef SSL_OP_NO_COMPRESSION
 		options |= SSL_OP_NO_COMPRESSION;
+#endif
 		options |= SSL_OP_DONT_INSERT_EMPTY_FRAGMENTS;
 		SSL_CTX_set_options(g_ssl_ctx, options);
 	}
