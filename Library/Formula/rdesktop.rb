require 'formula'

class Rdesktop < Formula
  homepage 'http://www.rdesktop.org/'

  # Note: please do not upgrade to version 1.8.x, as the keyboard and mouse
  # do not work well in OSX. We should wait for this issue to be fixed first:
  # http://sourceforge.net/p/rdesktop/bugs/376/
  url 'https://downloads.sourceforge.net/project/rdesktop/rdesktop/1.7.1/rdesktop-1.7.1.tar.gz'
  sha1 'c718d0f49948a964c7ef8424b8ade73ecce3aba3'

  depends_on "openssl"
  depends_on :x11

  patch :DATA

  def install
    args = ["--prefix=#{prefix}",
            "--disable-credssp",
            "--disable-smartcard", # disable temporally before upstream fix
            "--with-openssl=#{Formula["openssl"].opt_prefix}",
            "--x-includes=#{MacOS::X11.include}",
            "--x-libraries=#{MacOS::X11.lib}"]
    system "./configure", *args
    system "make install"
  end
end

# Note: The patch below is meant to remove the reference to the undefined symbol
# SCARD_CTL_CODE. Since we are compiling with --disable-smartcard, we don't need
# it anyway (and it should probably have been #ifdefed in the original code).

__END__
diff --git a/scard.c b/scard.c
index caa0745..5521ee9 100644
--- a/scard.c
+++ b/scard.c
@@ -2152,7 +2152,6 @@ TS_SCardControl(STREAM in, STREAM out)
	{
		/* Translate to local encoding */
		dwControlCode = (dwControlCode & 0x3ffc) >> 2;
-		dwControlCode = SCARD_CTL_CODE(dwControlCode);
	}
	else
	{
@@ -2198,7 +2197,7 @@ TS_SCardControl(STREAM in, STREAM out)
	}

 #ifdef PCSCLITE_VERSION_NUMBER
-	if (dwControlCode == SCARD_CTL_CODE(3400))
+	if (0)
	{
		int i;
		SERVER_DWORD cc;
