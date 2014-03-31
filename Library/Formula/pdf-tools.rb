require "formula"

class PdfTools < Formula
  homepage "https://github.com/politza/pdf-tools"
  url "https://github.com/politza/pdf-tools.git"
  sha1 "7d6beaf40869f953268f30dd3f6bc7913e2ca125"
  version "0.20"

  depends_on "pkg-config" => :build

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  depends_on "cairo"
  depends_on "zlib"
  depends_on "poppler" => "with-glib"

  patch :DATA

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "cp pdf-tools-0.20.tar #{prefix}"
    system "mkdir -p #{prefix}/elpa"
    system "tar --strip-components=1 -xf pdf-tools-0.20.tar -C #{prefix}/elpa"
  end

  def caveats; <<-EOS.undent
    How to install to your Emacs, run

    emacs -Q --batch --eval "(package-install-file \\"#{prefix}/pdf-tools-0.20.tar\\")"
    EOS
  end
end

__END__
diff --git i/src/epdfinfo.c w/src/epdfinfo.c
index 01001ff..849ae4c 100644
--- i/src/epdfinfo.c
+++ w/src/epdfinfo.c
@@ -15,6 +15,7 @@
 // You should have received a copy of the GNU General Public License
 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
+#include <stdbool.h>
 #include <assert.h>
 #include <err.h>
 #include <error.h>
@@ -32,6 +33,10 @@
 #include "epdfinfo.h"
 #include "config.h"
 
+#ifdef __APPLE__
+#  define error printf
+#endif
+
 
 /* declarations */
 static arg_t *parse_args(const ctxt_t *ctx, const char *args, size_t len,
@@ -2132,3 +2137,4 @@ mktempfile()
 
   return filename;
 }
+

diff --git c/src/error.h i/src/error.h
new file mode 100644
index 0000000..275da9b
--- /dev/null
+++ i/src/error.h
@@ -0,0 +1,61 @@
+//========================================================================
+//
+// Error.h
+//
+// Copyright 1996-2003 Glyph & Cog, LLC
+//
+//========================================================================
+
+//========================================================================
+//
+// Modified under the Poppler project - http://poppler.freedesktop.org
+//
+// All changes made under the Poppler project to this file are licensed
+// under GPL version 2 or later
+//
+// Copyright (C) 2005, 2007 Jeff Muizelaar <jeff@infidigm.net>
+// Copyright (C) 2005 Albert Astals Cid <aacid@kde.org>
+// Copyright (C) 2005 Kristian Høgsberg <krh@redhat.com>
+// Copyright (C) 2013 Adrian Johnson <ajohnson@redneon.com>
+//
+// To see a description of the changes please see the Changelog file that
+// came with your tarball or type make ChangeLog if you are building from git
+//
+//========================================================================
+
+#ifndef ERROR_H
+#define ERROR_H
+
+#ifdef USE_GCC_PRAGMAS
+#pragma interface
+#endif
+
+#include <stdarg.h>
+#include "poppler-config.h"
+#include "goo/gtypes.h"
+
+enum ErrorCategory {
+  errSyntaxWarning,    // PDF syntax error which can be worked around;
+                       //   output will probably be correct
+  errSyntaxError,      // PDF syntax error which can be worked around;
+                       //   output will probably be incorrect
+  errConfig,           // error in Xpdf config info (xpdfrc file, etc.)
+  errCommandLine,      // error in user-supplied parameters, action not
+                       //   allowed, etc. (only used by command-line tools)
+  errIO,               // error in file I/O
+  errNotAllowed,       // action not allowed by PDF permission bits
+  errUnimplemented,    // unimplemented PDF feature - display will be
+                       //   incorrect
+  errInternal          // internal error - malfunction within the Xpdf code
+};
+
+typedef enum ErrorCategory ErrorCategory;
+
+extern void setErrorCallback(void (*cbk)(void *data, ErrorCategory category,
+                    Goffset pos, char *msg),
+                void *data);
+
+extern void CDECL error(ErrorCategory category, Goffset pos, const char *msg, ...);
+
+#endif
+

