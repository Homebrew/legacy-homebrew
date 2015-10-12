class Procmail < Formula
  desc "Sort incoming mail into separate folders/files"
  homepage "http://www.procmail.org/"
  url "ftp://ftp.procmail.net/pub/procmail/procmail-3.22.tar.gz"
  mirror "ftp://ftp.ucsb.edu/pub/mirrors/procmail/procmail-3.22.tar.gz"
  sha256 "087c75b34dd33d8b9df5afe9e42801c9395f4bf373a784d9bc97153b0062e117"

  depends_on "autoconf" => :build

  keg_only :provided_pre_el_capitan

  patch :p1, :DATA

  def install
    system "make", "BASENAME=#{prefix}", "LOCKINGTEST=/tmp", "install.bin"
    system "make", "BASENAME=#{share}", "install.man"
  end

  test do
    system "#{bin}/procmail", "-v"
  end
end

# The getline() used in procmail original code is conflict with Mac OS X
# system function, so need to replace "getline" with other name(i.e: get_line).
# Please see the following links for more info.
# error message:
# https://trac.macports.org/ticket/30353
# about getline():
# https://developer.apple.com/library/prerelease/mac/documentation/Darwin/Reference/ManPages/man3/getline.3.html

__END__
diff -Naur procmail-3.22-getline/src/fields.c procmail-3.22/src/fields.c
--- procmail-3.22-getline/src/fields.c	2015-06-13 14:43:11.000000000 +0900
+++ procmail-3.22/src/fields.c	2015-06-13 14:00:14.000000000 +0900
@@ -110,16 +110,16 @@
 		    /* try and append one valid field to rdheader from stdin */
 int readhead P((void))
 { int idlen;
-  getline();
+  get_line();
   if((idlen=breakfield(buf,buffilled))<=0) /* not the start of a valid field */
      return 0;
   if(idlen==STRLEN(FROM)&&eqFrom_(buf))			/* it's a From_ line */
    { if(rdheader)
 	return 0;			       /* the From_ line was a fake! */
-     for(;buflast=='>';getline());	    /* gather continued >From_ lines */
+     for(;buflast=='>';get_line());	    /* gather continued >From_ lines */
    }
   else
-     for(;;getline())		      /* get the rest of the continued field */
+     for(;;get_line())		      /* get the rest of the continued field */
       { switch(buflast)			     /* will this line be continued? */
 	 { case ' ':case '\t':				  /* yep, it sure is */
 	      continue;
diff -Naur procmail-3.22-getline/src/formail.c procmail-3.22/src/formail.c
--- procmail-3.22-getline/src/formail.c	2015-06-13 14:43:11.000000000 +0900
+++ procmail-3.22/src/formail.c	2015-06-13 14:00:45.000000000 +0900
@@ -819,7 +819,7 @@
       { if(split)		       /* gobble up the next start separator */
 	 { buffilled=0;
 #ifdef sMAILBOX_SEPARATOR
-	   getline();buffilled=0;		 /* but only if it's defined */
+	   get_line();buffilled=0;		 /* but only if it's defined */
 #endif
 	   if(buflast!=EOF)					   /* if any */
 	      goto splitit;
diff -Naur procmail-3.22-getline/src/formisc.c procmail-3.22/src/formisc.c
--- procmail-3.22-getline/src/formisc.c	2015-06-13 14:43:11.000000000 +0900
+++ procmail-3.22/src/formisc.c	2015-06-13 14:01:12.000000000 +0900
@@ -115,7 +115,7 @@
   buf[buffilled++]=c;
 }

-int getline P((void))			   /* read a newline-terminated line */
+int get_line P((void))			   /* read a newline-terminated line */
 { if(buflast==EOF)			 /* at the end of our Latin already? */
    { loadchar('\n');					  /* fake empty line */
      return EOF;					  /* spread the word */
diff -Naur procmail-3.22-getline/src/formisc.h procmail-3.22/src/formisc.h
--- procmail-3.22-getline/src/formisc.h	1999-04-19 15:42:15.000000000 +0900
+++ procmail-3.22/src/formisc.h	2015-06-13 14:01:40.000000000 +0900
@@ -17,4 +17,4 @@
 char*
  skipwords P((char*start));
 int
- getline P((void));
+ get_line P((void));
