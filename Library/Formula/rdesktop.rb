require 'formula'

class Rdesktop < Formula
	homepage 'http://www.rdesktop.org/'
	url 'http://downloads.sourceforge.net/project/rdesktop/rdesktop/1.8.0/rdesktop-1.8.0.tar.gz'
	sha1 '2d39a41d29ad1ad2509d1e343a2817a3c7d666de'

	depends_on :x11

	def install
		args = ["--prefix=#{prefix}", "--disable-credssp", "--disable-smartcard", "--with-openssl=#{MacOS.sdk_path}/usr"]
		args << "--x-includes=/opt/X11/include" if MacOS.version >= :mavericks
		system "./configure", *args
		system "make install"
	end

	def patches
		DATA
	end
end

__END__
diff --git a/tcp.c b/tcp.c
index a541e45..af1ac45 100644
--- a/tcp.c
+++ b/tcp.c
@@ -318,7 +318,9 @@ tcp_tls_connect(void)
 		}
 
 		options = 0;
+#ifdef SSL_OP_NO_COMPRESSION
 		options |= SSL_OP_NO_COMPRESSION;
+#endif
 		options |= SSL_OP_DONT_INSERT_EMPTY_FRAGMENTS;
 		SSL_CTX_set_options(g_ssl_ctx, options);
 	}

diff --git a/tcp.c b/tcp.c
index af1ac45..943a655 100644
--- a/tcp.c
+++ b/tcp.c
@@ -193,7 +193,7 @@ tcp_recv(STREAM s, uint32 length)
 	int rcvd = 0, ssl_err;
 
 	if (g_network_error == True)
-		return;
+		return NULL;
 
 	if (s == NULL)
 	{

