require 'formula'

class Ctags < Formula
  url 'http://downloads.sourceforge.net/ctags/ctags-5.8.tar.gz'
  homepage 'http://ctags.sourceforge.net/'
  md5 'c00f82ecdcc357434731913e5b48630d'

  head 'https://ctags.svn.sourceforge.net/svnroot/ctags/trunk'

  # true for both 5.8 and head
  fails_with_llvm "Resulting executable generates erroneous tag files", :build => 2335

  # Patch from FreeBSD's devel/ctags port
  # Install as exctags since emacs also installs ctags
  def patches
    DATA
  end

  def install
    if ARGV.build_head?
      system "autoheader"
      system "autoconf"
    end
    system "./configure", "--prefix=#{prefix}",
                          "--enable-macro-patterns",
                          "--mandir=#{man}",
                          "--with-readlib"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Exuberant ctags has been installed as exctags.
    EOS
  end
end
__END__
diff --git a/Makefile.in b/Makefile.in
index c24764e..76e4aaa 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -6,7 +6,7 @@
 # These are the names of the installed programs, in case you wish to change
 # them.
 #
-CTAGS_PROG = ctags
+CTAGS_PROG = exctags
 ETAGS_PROG = etags
 
 # Set this to the path to your shell (must run Bourne shell commands).
diff --git a/ctags.1 b/ctags.1
index 2d89006..69248a0 100644
--- a/ctags.1
+++ b/ctags.1
@@ -2,18 +2,18 @@
 
 
 .SH "NAME"
-ctags \- Generate tag files for source code
+exctags \- Generate tag files for source code
 
 
 .SH SYNOPSIS
 .TP 6
-\fBctags\fP [\fBoptions\fP] [\fIfile(s)\fP]
+\fBexctags\fP [\fBoptions\fP] [\fIfile(s)\fP]
 .TP 6
 \fBetags\fP [\fBoptions\fP] [\fIfile(s)\fP]
 
 
 .SH "DESCRIPTION"
-The \fBctags\fP and \fBetags\fP programs (hereinafter collectively referred to
+The \fBexctags\fP and \fBetags\fP programs (hereinafter collectively referred to
 as \fBctags\fP, except where distinguished) generate an index (or "tag") file
 for a variety of language objects found in \fIfile(s)\fP.
 This tag file allows these items to be quickly and easily located by a text