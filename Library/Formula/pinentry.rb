class Pinentry < Formula
  desc "Passphrase entry dialog utilizing the Assuan protocol"
  homepage "https://www.gnupg.org/related_software/pinentry/index.en.html"
  url "ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.4.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.4.tar.bz2"
  sha256 "4b8835bb738d464542b62020ff6b8f649a621540edb61c4cbfe0c894538ee2e0"

  bottle do
    cellar :any
    sha256 "7355da76546d02a42f60922fb1786b05e10a80706d3e0da9b3a49e45f5993f79" => :yosemite
    sha256 "49d718588e9a4c9f609636ba6d53aa88421b737a93e154ed30216df02aa8a5be" => :mavericks
    sha256 "706ee6a2fcfca3259e94ca3b76665136066c1755229d0f3e4cb460e85f7e1b24" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-pinentry-qt4",
                          "--disable-pinentry-gtk2",
                          "--disable-pinentry-gnome3"
    system "make", "install"
  end

  test do
    system "#{bin}/pinentry", "--version"
  end
end

__END__
diff --git a/pinentry/pinentry-curses.c b/pinentry/pinentry-curses.c
index 235435a..784c770 100644
--- a/pinentry/pinentry-curses.c
+++ b/pinentry/pinentry-curses.c
@@ -705,7 +705,11 @@ dialog_input (dialog_t diag, int alt, int chr)
   switch (chr)
     {
     case KEY_BACKSPACE:
-    case 'h' - 'a' + 1: /* control-h.  */
+      /* control-h.  */
+    case 'h' - 'a' + 1:
+      /* ASCII DEL.  What Mac OS X apparently emits when the "delete"
+	 (backspace) key is pressed.  */
+    case 127:
       if (diag->pin_len > 0)
 	{
 	  diag->pin_len--;
