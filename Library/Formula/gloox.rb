require 'formula'

class Gloox <Formula
  url 'http://camaya.net/download/gloox-1.0.tar.bz2'
  homepage 'http://camaya.net/glooxdownload'
  md5 'f8eacf1c6476e0a309b453fd04f90e31'

  depends_on 'pkg-config' => :build

  def patches
    # Fix memory leak
    # http://bugs.camaya.net/horde/whups/ticket/?id=181
    DATA
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-openssl",
                          "--without-gnutls",
                          "--with-zlib"
    system "make install"
  end
end

__END__
diff --git a/src/tlsgnutlsbase.cpp b/src/tlsgnutlsbase.cpp
index d98c802..37f702d 100644
--- a/src/tlsgnutlsbase.cpp
+++ b/src/tlsgnutlsbase.cpp
@@ -97,7 +97,7 @@ namespace gloox
     gnutls_bye( *m_session, GNUTLS_SHUT_RDWR );
     gnutls_db_remove_session( *m_session );
     gnutls_credentials_clear( *m_session );
-    if( m_secure )
+    if( m_session )
       gnutls_deinit( *m_session );
 
     m_secure = false;
diff --git a/src/tlsgnutlsclient.cpp b/src/tlsgnutlsclient.cpp
index c1d24c2..d250f32 100644
--- a/src/tlsgnutlsclient.cpp
+++ b/src/tlsgnutlsclient.cpp
@@ -33,6 +33,8 @@ namespace gloox
   void GnuTLSClient::cleanup()
   {
     GnuTLSBase::cleanup();
+    if (m_credentials)
+        gnutls_certificate_free_credentials( m_credentials );
     init();
   }
 
@@ -120,6 +122,7 @@ namespace gloox
       m_certInfo.status |= CertSignerNotCa;
     const gnutls_datum_t* certList = 0;
     unsigned int certListSize;
+    unsigned int certListSizeFull;
     if( !error && ( ( certList = gnutls_certificate_get_peers( *m_session, &certListSize ) ) == 0 ) )
       error = true;
 
@@ -131,6 +134,7 @@ namespace gloox
         error = true;
     }
 
+    certListSizeFull = certListSize;
     if( ( gnutls_x509_crt_check_issuer( cert[certListSize-1], cert[certListSize-1] ) > 0 )
          && certListSize > 0 )
       certListSize--;
@@ -189,7 +193,7 @@ namespace gloox
     if( !gnutls_x509_crt_check_hostname( cert[0], m_server.c_str() ) )
       m_certInfo.status |= CertWrongPeer;
 
-    for( unsigned int i = 0; i < certListSize; ++i )
+    for( unsigned int i = 0; i < certListSizeFull; ++i )
       gnutls_x509_crt_deinit( cert[i] );
 
     delete[] cert;
