class Pinentry < Formula
  desc "Passphrase entry dialog utilizing the Assuan protocol"
  homepage "https://www.gnupg.org/related_software/pinentry/index.en.html"
  url "ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.4.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-0.9.4.tar.bz2"
  sha256 "4b8835bb738d464542b62020ff6b8f649a621540edb61c4cbfe0c894538ee2e0"

  bottle do
    cellar :any
    revision 1
    sha256 "d6caa258ee85016f4eae79c6ee42745f0b3f16d6572c8eebc5be7a70384184d3" => :yosemite
    sha256 "772335dcc0286d88679240a68fca2555fbb347917f2a1c54e07f4afe9858fbda" => :mavericks
    sha256 "9f7ad30cddaaf46eb49e781b82a95200679e0d93274f33b81e270421db00b9f6" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  # Fix backspacing in pinentry-curses.  Remove at next release.
  # https://bugs.gnupg.org/gnupg/issue2020
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
