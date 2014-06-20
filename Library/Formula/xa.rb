require 'formula'

class Xa < Formula
  homepage 'http://www.floodgap.com/retrotech/xa/'
  url 'http://www.floodgap.com/retrotech/xa/dists/xa-2.3.5.tar.gz'
  sha1 'd8f4564953adfcee69faacfa300b954875fabe21'

  # From upstream: http://www.floodgap.com/retrotech/xa/xa-getline-patch.txt
  # Filenames have been changed in the header ("xa.c" -> "a/src/xa.c")
  # because the original patch can't be applied with -p0 or -p1.
  # This fix will be in 2.3.6
  patch :DATA

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "DESTDIR=#{prefix}",
                   "install"
  end

  test do
    (testpath/"foo.a").write "jsr $ffd2\n"

    system "#{bin}/xa", "foo.a"
    code = File.open("a.o65", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0x20, 0xd2, 0xff], code
  end
end

__END__
--- a/src/xa.c	2014-02-07 13:50:18.000000000 -0800
+++ b/src/xa.c	2014-02-07 13:51:27.000000000 -0800
@@ -87,7 +87,7 @@
 static int puttmp(int);
 static int puttmps(signed char *, int);
 static void chrput(int);
-static int getline(char *);
+static int xgetline(char *);
 static void lineout(void);
 static long ga_p1(void);
 static long gm_p1(void);
@@ -763,7 +763,7 @@
 	temp_er = 0;
 
 /*FIXIT*/
-     while(!(er=getline(s)))
+     while(!(er=xgetline(s)))
      {         
           er=t_p1((signed char*)s,o,&l,&al);
 	  switch(segment) {
@@ -1002,7 +1002,7 @@
 
 static char l[MAXLINE];
 
-static int getline(char *s)
+static int xgetline(char *s)
 {
      static int ec;
 
