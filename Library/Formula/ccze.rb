class Ccze < Formula
  desc "Robust and modular log colorizer"
  homepage "https://packages.debian.org/wheezy/ccze"
  url "http://ftp.de.debian.org/debian/pool/main/c/ccze/ccze_0.2.1.orig.tar.gz"
  sha256 "8263a11183fd356a033b6572958d5a6bb56bfd2dba801ed0bff276cfae528aa3"

  depends_on "pcre"

  # Taken from debian
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-builtins=all"
    system "make", "install"
    # Strange but true: using --mandir above causes the build to fail!
    share.install prefix/"man"
  end

  test do
    system "#{bin}/ccze", "--help"
  end
end

__END__
diff --git a/src/Makefile.in b/src/Makefile.in
index c6f9892..9b93b65 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -22,7 +22,7 @@ WFLAGS_GCC	= -Wshadow -Wpointer-arith -Waggregate-return \
		-Wbad-function-cast -Wsign-compare -Wchar-subscripts \
		-Wcomment -Wformat -Wformat-nonliteral -Wformat-security \
		-Wimplicit -Wmain -Wmissing-braces -Wparentheses \
-		-Wreturn-type -Wswitch -Wmulticharacter \
+		-Wreturn-type -Wswitch \
		-Wmissing-noreturn -Wmissing-declarations @WFLAGS_3X@
 WFLAGS_ICC	= -Wall -wd193,279,810,869,1418,1419
 WFLAGS_3X	= -Wsequence-point -Wdiv-by-zero -W -Wunused \
