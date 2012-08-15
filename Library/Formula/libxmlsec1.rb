require 'formula'

class Libxmlsec1 < Formula
  homepage 'http://www.aleksey.com/xmlsec/'
  url 'http://www.aleksey.com/xmlsec/download/xmlsec1-1.2.18.tar.gz'
  md5 '8694b4609aab647186607f79e1da7f1a'

  depends_on 'pkg-config' => :build
  depends_on 'libxml2' # Version on 10.6/10.7 is too old
  depends_on 'gnutls' => :optional

  # Add HOMEBREW_PREFIX/lib to dl load path
  def patches; DATA; end

  def install
    libxml2 = Formula.factory('libxml2')

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libxml=#{libxml2.prefix}",
                          "--disable-crypto-dl",
                          "--disable-apps-crypto-dl"
    system "make install"
  end
end

__END__
diff --git a/src/dl.c b/src/dl.c
index 6e8a56a..0e7f06b 100644
--- a/src/dl.c
+++ b/src/dl.c
@@ -141,6 +141,7 @@ xmlSecCryptoDLLibraryCreate(const xmlChar* name) {
     }
 
 #ifdef XMLSEC_DL_LIBLTDL
+    lt_dlsetsearchpath("HOMEBREW_PREFIX/lib");
     lib->handle = lt_dlopenext((char*)lib->filename);
     if(lib->handle == NULL) {
         xmlSecError(XMLSEC_ERRORS_HERE,
