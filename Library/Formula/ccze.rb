class Ccze < Formula
  desc "Robust and modular log colorizer"
  homepage "https://packages.debian.org/wheezy/ccze"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/c/ccze/ccze_0.2.1.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/ccze/ccze_0.2.1.orig.tar.gz"
  sha256 "8263a11183fd356a033b6572958d5a6bb56bfd2dba801ed0bff276cfae528aa3"

  bottle do
    sha256 "7eb127c4017e7530a53e3258f6b013e80fca1a0d30c577813bdc326b8b0e30d3" => :el_capitan
    sha256 "3bf7f9c6ab3410d73348d4f0518f4778ca2e832904f992004bd3a438d2fcd036" => :yosemite
    sha256 "8714d3dbc5bc165b505180b9833fbcdda609e978c6c821ac7a503cd4226619aa" => :mavericks
  end

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
