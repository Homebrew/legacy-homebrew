require 'formula'

class Gnutls <Formula
  url 'http://ftp.gnu.org/pub/gnu/gnutls/gnutls-2.10.4.tar.bz2'
  homepage 'http://www.gnu.org/software/gnutls/gnutls.html'
  sha1 'f0dcd7b68748b48d7b945c52b6a9e64d643e4b58'

  depends_on 'pkg-config' => :build
  depends_on 'libgcrypt'
  depends_on 'libtasn1' => :optional

  def patches
    DATA
  end

  def install
    fails_with_llvm "Undefined symbols when linking", :build => "2326"

    ENV.universal_binary	# build fat so wine can use it

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-guile"
    system "make install"
  end
end

__END__
diff --git a/src/serv.c b/src/serv.c
index 0307b05..ecd8725 100644
--- a/src/serv.c
+++ b/src/serv.c
@@ -440,6 +440,7 @@ static const char DEFAULT_DATA[] =
  */
 #define tmp2 &http_buffer[strlen(http_buffer)], len-strlen(http_buffer)
 static char *
+#undef snprintf
 peer_print_info (gnutls_session_t session, int *ret_length,
		 const char *header)
 {
