require 'formula'

class Gnutls < Formula
  homepage 'http://www.gnu.org/software/gnutls/gnutls.html'
  url 'ftp://ftp.gnu.org/gnu/gnutls/gnutls-2.12.2.tar.bz2'
  sha256 'cc964ee51350449142221e7efef2d5ea60459539484538e282c3b48183ab7e43'

  depends_on 'pkg-config' => :build
  depends_on 'libgcrypt'
  depends_on 'libtasn1' => :optional

  def patches
    DATA
  end

  fails_with_llvm "Undefined symbols when linking", :build => "2326"

  def install
    ENV.universal_binary	# build fat so wine can use it

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-guile",
                          "--disable-static",
                          "--prefix=#{prefix}",
                          "--with-libgcrypt"
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
