require 'formula'

class Movgrab < Formula
  homepage 'http://sites.google.com/site/columscode'
  url 'http://sites.google.com/site/columscode/files/movgrab-1.1.10.tgz'
  sha1 '2a87105501a3397d513c495d9d1f982ef2e09195'

  def patches
    # 1-3 fix Clang compile errors: non-void functions should return a value
    # 4 fixes Clang compile error: c99 "inline" function -> unresolved symbols.
    # All patches including the --no-recusion hack have been emailed upstream at
    # version 1.1.9.  As of 1.1.10, no reply from the developer.
    DATA
  end

  def install
    # When configure recurses into libUseful-2.0, it puts CC and CFLAGS into
    # the second configure command line causing an error, invalid host type.
    # The workaround is to manually configure libUseful-2.0 without those.
    # The cache-file and srcdir arguments parse ok.  So those were left in.
    system './configure', "--prefix=#{prefix}", '--no-recursion'
    cd 'libUseful-2.0' do
      system './configure', "--prefix=#{prefix}",
                            '--cache-file=/dev/null',
                            '--srcdir=.'
    end
    system 'make'
    system 'make install'
  end
end

__END__
--- a/main.c	2012-02-10 07:34:13.000000000 -0800
+++ b/main.c	2012-02-12 10:22:28.000000000 -0800
@@ -76,7 +76,7 @@
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
