require 'formula'

class Movgrab < Formula
  url 'http://sites.google.com/site/columscode/files/movgrab-1.1.9.tgz'
  homepage 'http://sites.google.com/site/columscode'
  sha1 'd1439dea2a2ae2c0ef14322bac3693c57275570e'

  def patches
    # diffs 1-3 fix compile errors with Clang, non-void functions should return a value
    # diff 4 fixes compile error with Clang, c99 "inline" function -> unresolved symbols.
    # All patches including the --no-recusion hack have been emailed upstream.
    DATA
  end

  def install
    # If we let configure recurse into libUseful-2.0, it propogates CC and CFLAGS into
    # the second configure command line, which configure can't parse, causing an error.
    # The workaround is to manually configure libUseful-2.0 without the env vars.
    # The cache-file and srcdir arguments parse ok.  So those were left in.
    system "./configure", "--prefix=#{prefix}", "--no-recursion"
    cd 'libUseful-2.0' do
      system "./configure", "--prefix=#{prefix}", '--cache-file=/dev/null', '--srcdir=.'
    end
    system "make"
    system "make install"
  end
end

__END__
--- a/main.c	2012-02-10 07:34:13.000000000 -0800
+++ b/main.c	2012-02-12 10:22:28.000000000 -0800
@@ -78,7 +78,7 @@
 int Port;
 int RetVal=FALSE;
 
-if (!StrLen(Path)) return;
+if (!StrLen(Path)) return(FALSE);
 
 Type=MovType;
 NextPath=CopyStr(NextPath,Path);
--- a/libUseful-2.0/file.c	2012-01-28 04:09:00.000000000 -0800
+++ b/libUseful-2.0/file.c	2012-02-12 10:23:03.000000000 -0800
@@ -515,7 +515,7 @@
 {
 int len;
 
-if (! S) return;
+if (! S) return(NULL);
 len=S->OutEnd - S->OutStart; 
 
 STREAMReadThroughProcessors(S, NULL, 0);
--- a/libUseful-2.0/sound.c	2012-01-23 21:28:28.000000000 -0800
+++ b/libUseful-2.0/sound.c	2012-02-12 10:23:24.000000000 -0800
@@ -416,7 +416,7 @@
 {
 int result, fd;
 
-if (StrLen(SoundFilePath) < 1) return;
+if (StrLen(SoundFilePath) < 1) return(FALSE);
 #ifdef HAVE_LIBESD
 
 fd=ESDGetConnection();
--- a/libUseful-2.0/string.h	2012-01-23 21:28:28.000000000 -0800
+++ b/libUseful-2.0/string.h	2012-02-12 10:23:44.000000000 -0800
@@ -31,8 +31,8 @@
 char *VFormatStr(char *,const char *,va_list);
 char *FormatStr(char *,const char *,...);
 char *AddCharToStr(char *,char);
-inline char *AddCharToBuffer(char *Buffer, int BuffLen, char Char);
-inline char *AddBytesToBuffer(char *Buffer, int BuffLen, char *Bytes, int Len);
+char *AddCharToBuffer(char *Buffer, int BuffLen, char Char);
+char *AddBytesToBuffer(char *Buffer, int BuffLen, char *Bytes, int Len);
 char *SetStrLen(char *,int);
 char *strlwr(char *);
 char *strrep(char *,char, char);
