require 'formula'
require 'fileutils'

class Xdu < Formula
  homepage 'http://sd.wareonearth.com/~phil/xdu/'
  url 'http://sd.wareonearth.com/~phil/xdu/xdu-3.0.tar.Z'
  sha1 '196e2ba03253fd6b8a88fafe6b00e40632183d0c'

  depends_on :x11

  def patches
     # Fix handling of file names with spaces
     # Make code compile with Apple's compiler
     DATA;
  end

  def install
    system "#{ENV.cc} -o xdu xdu.c xwin.c -lXaw -lXt -lXext -lX11 -I#{MacOS::X11.include} -L#{MacOS::X11.lib}"
    bin.install "xdu"
    man1.install "xdu.man" => "xdu.1"
  end
end

__END__
--- xdu-3.0/xwin.c~	1994-06-05 21:29:24.000000000 +0200
+++ xdu-3.0/xwin.c	2013-06-13 16:02:46.000000000 +0200
@@ -45,12 +45,12 @@
 extern int ncols;
 
 /* EXPORTS: routines that this module exports outside */
-extern int xsetup();
+extern void xsetup();
 extern int xmainloop();
-extern int xclear();
-extern int xrepaint();
+extern void xclear();
+extern void xrepaint();
 extern int xrepaint_noclear();
-extern int xdrawrect();
+extern void xdrawrect();
 
 /* internal routines */
 static void help_popup();
@@ -295,7 +295,7 @@
 
 /*  External Functions  */
 
-int
+void
 xsetup(argcp, argv)
 int *argcp;
 char **argv;
@@ -355,12 +355,12 @@
 	return(0);
 }
 
-xclear()
+void xclear()
 {
 	XClearWindow(dpy, win);
 }
 
-xrepaint()
+void xrepaint()
 {
 	XWindowAttributes xwa;
 
@@ -377,7 +377,7 @@
 	repaint(xwa.width, xwa.height);
 }
 
-xdrawrect(name, size, x, y, width, height)
+void xdrawrect(name, size, x, y, width, height)
 char *name;
 int size;
 int x, y, width, height;
--- xdu-3.0/xdu.c~	1994-06-05 21:29:23.000000000 +0200
+++ xdu-3.0/xdu.c	2013-06-14 11:55:27.000000000 +0200
@@ -30,7 +30,8 @@
 #define	NCOLS		5	/* default number of columns in display */
 
 /* What we IMPORT from xwin.c */
-extern int xsetup(), xmainloop(), xdrawrect(), xrepaint();
+extern void xsetup(), xdrawrect(), xrepaint();
+extern int xmainloop();
 
 /* What we EXPORT to xwin.c */
 extern int press(), reset(), repaint(), setorder(), reorder();
@@ -232,7 +233,6 @@
 char *filename;
 {
 	char	buf[4096];
-	char	name[4096];
 	int	size;
 	FILE	*fp;
 
@@ -245,9 +245,10 @@
 		}
 	}
 	while (fgets(buf,sizeof(buf),fp) != NULL) {
-		sscanf(buf, "%d %s\n", &size, name);
-		/*printf("%d %s\n", size, name);*/
-		parse_entry(name,size);
+		int offset;
+		sscanf(buf, "%d %n", &size, &offset);
+		/* printf("%d %s", size, buf+offset); */
+		parse_entry(buf+offset, size);
 	}
 	fclose(fp);
 }
@@ -266,7 +267,9 @@
 	if (*name == '/')
 		name++;		/* skip leading / */
 
-	length = strlen(name);
+	length = strlen(name) - 1;
+	/* Stripping newline */
+	name[length] = 0;
 	if ((length > 0) && (name[length-1] == '/')) {
 		/* strip off trailing / (e.g. GNU du) */
 		name[length-1] = 0;

