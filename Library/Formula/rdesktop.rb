require "formula"

class Rdesktop < Formula
  homepage "http://www.rdesktop.org/"
  url "https://downloads.sourceforge.net/project/rdesktop/rdesktop/1.8.2/rdesktop-1.8.2.tar.gz"
  sha1 "089e8f2b18688ded8afc659de5ba8d5b14c7b874"
  revision 1

  bottle do
    sha1 "ab2c80243535d1d5dadfe660da2f00c834e07f62" => :mavericks
    sha1 "bc754bfedc56617646c663c49e2c174e54d8c1a8" => :mountain_lion
    sha1 "7ae49942da08b4ab54aa6a7a072f62cb2def8062" => :lion
  end

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
    system "make", "install"
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
