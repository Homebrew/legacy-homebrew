require 'formula'

class Nfcutils < Formula
  url 'http://nfc-tools.googlecode.com/files/nfcutils-0.3.0.tar.gz'
  homepage 'http://code.google.com/p/nfc-tools/'
  md5 '161d640eb7f8d17762f57f7b27437f33'
  head 'http://nfc-tools.googlecode.com/svn/trunk/nfcutils', :using => :svn

  depends_on 'libnfc'

  def patches
    # fixes compatibility with libnfc >= 1.5.1
    # is already fixed in --HEAD
    if @version == "0.3.0"
        DATA
    end
  end

  def install
    if ARGV.build_head?
      ENV['ACLOCAL'] = "/usr/bin/aclocal -I m4 -I #{HOMEBREW_PREFIX}/share/aclocal"

      system "autoreconf -vis" 
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/src/lsnfc.c b/src/lsnfc.c
index fe0b8e4..7482379 100644
--- a/src/lsnfc.c
+++ b/src/lsnfc.c
@@ -81,7 +81,7 @@ mifare_ultralight_identification(const nfc_iso14443a_info_t nai)
   };
   if(nfc_initiator_select_passive_target(pnd, nm, nai.abtUid, nai.szUidLen, NULL) ) {
     nfc_configure (pnd, NDO_EASY_FRAMING, false);
-    if (nfc_initiator_transceive_bytes(pnd, abtCmd,sizeof(abtCmd), abtRx, &szRxLen)) {
+    if (nfc_initiator_transceive_bytes(pnd, abtCmd,sizeof(abtCmd), abtRx, &szRxLen, NULL)) {
       // AUTH step1 command success, so it's a Ultralight C
       nfc_configure (pnd, NDO_EASY_FRAMING, true);
       nfc_initiator_deselect_target(pnd);
@@ -118,12 +118,12 @@ mifare_desfire_identification(const nfc_iso14443a_info_t nai)
     .nbr = NBR_106
   };
   if(nfc_initiator_select_passive_target(pnd, nm, nai.abtUid, nai.szUidLen, NULL) ) {
-    if (nfc_initiator_transceive_bytes(pnd, abtCmd, sizeof(abtCmd), abtRx, &szRxLen)) {
+    if (nfc_initiator_transceive_bytes(pnd, abtCmd, sizeof(abtCmd), abtRx, &szRxLen, NULL)) {
       // MIFARE DESFire GetVersion command success, decoding...
       if( szRxLen == 8 ) { // GetVersion should reply 8 bytes
         memcpy( abtDESFireVersion, abtRx + 1, 7 );
         abtCmd[0] = 0xAF; // ask for GetVersion next bytes
-        if (nfc_initiator_transceive_bytes(pnd, abtCmd, sizeof(abtCmd), abtRx, &szRxLen)) {
+        if (nfc_initiator_transceive_bytes(pnd, abtCmd, sizeof(abtCmd), abtRx, &szRxLen, NULL)) {
           if( szRxLen == 8 ) { // GetVersion should reply 8 bytes
             memcpy( abtDESFireVersion + 7, abtRx + 1, 7 );
             res = malloc(16); // We can alloc res: we will be able to provide information
