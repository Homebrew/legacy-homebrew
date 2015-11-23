class Pstoedit < Formula
  desc "Convert PostScript and PDF files to editable vector graphics"
  homepage "http://www.pstoedit.net"
  url "https://downloads.sourceforge.net/project/pstoedit/pstoedit/3.70/pstoedit-3.70.tar.gz"
  sha256 "06b86113f7847cbcfd4e0623921a8763143bbcaef9f9098e6def650d1ff8138c"

  bottle do
    revision 1
    sha256 "ebead6381ae8729b99868e77f53433123293b0153adea4399ce52b481dc79a30" => :el_capitan
    sha256 "7aaeb9a02ccedc2487890d021e56a5303d0e3b9a45a2ebb1a79d82136f5f98eb" => :yosemite
    sha256 "edf89792e82fd205773febafd90e9af391566fc20c1a48799854aa2ef1bf6888" => :mavericks
    sha256 "d1f51d8a33fe2f1d69200cee962bd8a0eb78cd891f174efa872a6d91fe11b35b" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "plotutils"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "xz" if MacOS.version < :mavericks

  # Fix for pstoedit search for plugins, thereby restoring formats that
  # worked in 3.62 but now don't in 3.70, including PIC, DXF, FIG, and
  # many others.
  #
  # This patch has been submitted upstream; see:
  # http://sourceforge.net/p/pstoedit/bugs/19/
  #
  # Taken from:
  # https://build.opensuse.org/package/view_file/openSUSE:Factory/pstoedit/pstoedit-pkglibdir.patch?expand=1
  #
  # This patch changes the behavior of "make install" so that:
  # * If common/plugindir is defined, it checks only that directory.
  # * It swaps the check order: First checks whether PSTOEDITLIBDIR exists. If
  #   it exists, it skips blind attempts to find plugins.
  # As PSTOEDITLIBDIR is always defined by makefile, the blind fallback will
  # be attempted only in obscure environments.
  patch :DATA

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"pstoedit", "-f", "pdf", test_fixtures("test.ps"), "test.pdf"
    assert File.exist?("test.pdf")
  end
end

__END__
diff --git a/doc/pstoedit.1 b/doc/pstoedit.1
index 763a87e..1bc0b0e 100644
--- a/doc/pstoedit.1
+++ b/doc/pstoedit.1
@@ -1,5 +1,5 @@
 '\" t
-.\" Manual page created with latex2man on Thu Jan  1 20:55:12 CET 2015
+.\" Manual page created with latex2man on Fri Mar 13 20:58:53 CET 2015
 .\" NOTE: This file is generated, DO NOT EDIT.
 .de Vb
 .ft CW
@@ -10,7 +10,7 @@
 
 .fi
 ..
-.TH "PSTOEDIT" "1" "01 January 2015" "Conversion Tools " "Conversion Tools "
+.TH "PSTOEDIT" "1" "13 March 2015" "Conversion Tools " "Conversion Tools "
 .SH NAME
 
 pstoedit
@@ -367,7 +367,7 @@ MS Windows: The same directory where the pstoedit executable is located
 .B *
 Unix:
 .br 
-<\fIThe directory where the pstoedit executable is located\fP>
+The default installation directory. If it fails, then <\fIThe directory where the pstoedit executable is located\fP>
 /../lib/ 
 .RS
 .PP
diff --git a/doc/pstoedit.htm b/doc/pstoedit.htm
index 2a2c500..e1ca481 100644
--- a/doc/pstoedit.htm
+++ b/doc/pstoedit.htm
@@ -1,5 +1,5 @@
 <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
-<!-- Manual page created with latex2man on Thu Jan  1 20:55:13 CET 2015
+<!-- Manual page created with latex2man on Fri Mar 13 20:58:54 CET 2015
 ** Author of latex2man: Juergen.Vollmer@informatik-vollmer.de
 ** NOTE: This file is generated, DO NOT EDIT. -->
 <html>
@@ -9,7 +9,7 @@
 PSTOEDIT 
 </h1>
 <h4 align=center>Dr. Wolfgang Glunz </h4>
-<h4 align=center>01 January 2015</h4>
+<h4 align=center>13 March 2015</h4>
 <h4 align=center>Version 3.70 </h4>
 <tt>pstoedit</tt>
 - a tool converting PostScript and PDF files into various 
@@ -561,7 +561,7 @@ in the installation directory and uses that file as a default fontmap file if av
 </li>
 <li>Unix:<br>
  
-&lt;<em>The directory where the pstoedit executable is located</em>&gt;
+The default installation directory. If it fails, then &lt;<em>The directory where the pstoedit executable is located</em>&gt;
 <tt>/../lib/</tt> 
 <p>
 </li>
diff --git a/doc/pstoedit.tex b/doc/pstoedit.tex
index a3d5494..7f590ea 100644
--- a/doc/pstoedit.tex
+++ b/doc/pstoedit.tex
@@ -352,7 +352,7 @@ If  the \Opt{-fontmap} option is not specified, \Prog{pstoedit} automatically lo
   \item MS Windows: The same directory where the \Prog{pstoedit} executable is located
 
   \item Unix:\\
-  $<$\emph{The directory where the pstoedit executable is located}$>$\verb+/../lib/+
+  The default installation directory. If it fails, then $<$\emph{The directory where the pstoedit executable is located}$>$\verb+/../lib/+
 
 \end{itemize}
 
diff --git a/src/pstoedit.cpp b/src/pstoedit.cpp
index 7f66d23..a16f57d 100644
--- a/src/pstoedit.cpp
+++ b/src/pstoedit.cpp
@@ -30,6 +30,7 @@
 #include I_string_h
 
 #include <assert.h>
+#include <sys/stat.h>
 
 #include "pstoeditoptions.h"
 
@@ -261,33 +262,33 @@ static void loadpstoeditplugins(const char *progname, ostream & errstream, bool
 		loadPlugInDrivers(plugindir.c_str(), errstream, verbose);	// load the driver plugins
 		pluginsloaded = true;
 	}
-	// also look in the directory where the pstoedit .exe/dll was found
-	char szExePath[1000];
-	szExePath[0] = '\0';
-	const unsigned long r = P_GetPathToMyself(progname, szExePath, sizeof(szExePath));
-	if (verbose)  errstream << "pstoedit : path to myself:" << progname << " " << r << " " << szExePath<< endl;
-	char *p = 0;
-	if (r && (p = strrchr(szExePath, directoryDelimiter)) != 0) {
-		*p = '\0';
-		if (!strequal(szExePath, plugindir.c_str())) {
-			loadPlugInDrivers(szExePath, errstream,verbose);
-			pluginsloaded = true;
-		}
-	}
-	// now try also $exepath/../lib/pstoedit
-	strcat_s(szExePath,1000,"/../lib/pstoedit");
-	if (!strequal(szExePath, plugindir.c_str())) {
-    	loadPlugInDrivers(szExePath, errstream,verbose);
-		pluginsloaded = true;
-	}
-
 #ifdef PSTOEDITLIBDIR
-	if (!pluginsloaded) {
+	struct stat s;
+	if (!pluginsloaded &&
+	    !stat(PSTOEDITLIBDIR, &s) &&
+	    S_ISDIR(s.st_mode)) {
   	  // also try to load drivers from the PSTOEDITLIBDIR
 	  loadPlugInDrivers(PSTOEDITLIBDIR, errstream,verbose);
 	  pluginsloaded = true;
 	}
 #endif
+	// If the above failed, also look in the directory where the pstoedit .exe/dll was found
+	if (!pluginsloaded) {
+	  char szExePath[1000];
+	  szExePath[0] = '\0';
+	  const unsigned long r = P_GetPathToMyself(progname, szExePath, sizeof(szExePath));
+	  if (verbose)  errstream << "pstoedit : path to myself:" << progname << " " << r << " " << szExePath<< endl;
+	  char *p = 0;
+	  if (r && (p = strrchr(szExePath, directoryDelimiter)) != 0) {
+		*p = '\0';
+		loadPlugInDrivers(szExePath, errstream,verbose);
+	  }
+	  // now try also $exepath/../lib/pstoedit
+	  strcat_s(szExePath,1000,"/../lib/pstoedit");
+	  if (!strequal(szExePath, plugindir.c_str())) {
+	  loadPlugInDrivers(szExePath, errstream,verbose);
+	  }
+	}
 
 	// delete[]plugindir;
 }
