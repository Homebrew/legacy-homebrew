require 'formula'

class GoogleAuthenticator < Formula
  homepage 'https://code.google.com/p/google-authenticator/'
  url 'https://google-authenticator.googlecode.com/files/libpam-google-authenticator-1.0-source.tar.bz2'
  sha1 '017b7d89989f1624e360abe02d6b27a6298d285d'

  head 'https://code.google.com/p/google-authenticator/', :using => :git

  depends_on 'qrencode' => :recommended if build.head?

  def patches
    # fixed libqrencode usage on OS X (Issue: #257)
    DATA if build.head?
  end

  def install
    cd 'libpam' if build.head?
    system "make"
    bin.install "google-authenticator"
    lib.install "pam_google_authenticator.so"
  end

  test do
    system "#{bin}/google-authenticator", "-h"
  end

  def caveats; <<-EOS.undent
    To use this pam module you have it activate manually in the wished pam file.

    Example /etc/pam.d/sshd:
    ...
    auth       required       /usr/local/lib/pam_google_authenticator.so
    ...

    EOS
  end

end

__END__
diff --git a/libpam/google-authenticator.c b/libpam/google-authenticator.c
index 717cc7b..c92c12b 100644
--- a/libpam/google-authenticator.c
+++ b/libpam/google-authenticator.c
@@ -192,6 +192,9 @@ static void displayQRCode(const char *secret, const char *label,
     if (!qrencode) {
       qrencode = dlopen("libqrencode.so.3", RTLD_NOW | RTLD_LOCAL);
     }
+    if (!qrencode) {
+      qrencode = dlopen("libqrencode.3.dylib", RTLD_NOW | RTLD_LOCAL);
+    }
     if (qrencode) {
       typedef struct {
         int version;
