require 'formula'

class Calc < Formula
  homepage 'http://www.isthe.com/chongo/tech/comp/calc/'
  url 'http://members.tip.net.au/%7Edbell/programs/calc-3.1.tar.gz'
  sha1 'befa3faf144827fd742bdde22d2e0c5aec50dd4c'
  
  depends_on 'readline'

  def patches
    {:p0 =>
      [DATA]
    };
  end

  def install
    ENV.deparallelize

    ENV['EXTRA_CFLAGS'] = ENV.cflags
    ENV['EXTRA_LDFLAGS'] = ENV.ldflags

    readline = Formula.factory('readline')
    inreplace "Makefile" do |s|
      s.change_make_var! "INCDIR", include
      s.change_make_var! "BINDIR", bin
      s.change_make_var! "LIBDIR", lib
      s.change_make_var! "MANDIR", man1
      s.change_make_var! "CALC_SHAREDIR", "#{share}/calc"
      s.change_make_var! "USE_READLINE", "-DUSE_READLINE"
      s.change_make_var! "READLINE_LIB", "-L#{readline.lib} -lreadline"
      s.change_make_var! "READLINE_EXTRAS", "-lhistory -lncurses"
      s.change_make_var! "LIBCALC_SHLIB",
        "-single_module -undefined dynamic_lookup -dynamiclib -install_name ${LIBDIR}/libcalc${LIB_EXT_VERSION}"
      s.change_make_var! "LIBCUSTCALC_SHLIB",
        "-single_module -undefined dynamic_lookup -dynamiclib -install_name ${LIBDIR}/libcustcalc${LIB_EXT_VERSION}"
      s.change_make_var! 'CC',
        "MACOSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET} #{ENV.cc}"
      s.change_make_var! 'MACOSX_DEPLOYMENT_TARGET',
        "#{MacOS.version}"
    end

    system "make"
    system "make install"
    libexec.install "#{bin}/cscript"
  end

  test do
    output = `#{bin}/calc 0xA + 1`.strip
    assert_equal "11", output
    assert_equal 0, $?.exitstatus
  end
end

__END__
diff -urN commands.c commands.c
--- commands.c 2009-08-01 06:59:56.000000000 +0200
+++ commands.c     2014-02-17 07:37:29.000000000 +0100
@@ -33,7 +33,7 @@
 #include "builtinfunc.h"
 #include "parse.h"

-static BOOL abort_now;
+BOOL abort_now;


 /*
diff -urN file.h file.h
--- file.h     2001-06-08 23:00:58.000000000 +0200
+++ file.h 2014-02-17 08:06:54.000000000 +0100
@@ -41,7 +41,7 @@
 # include <calc/have_fpos.h>
 #endif

-
+#include <sys/types.h>
 /*
  * Definition of opened files.
  */

diff -urN ../calc-3.1/CHANGES ./CHANGES
--- ../calc-3.1/CHANGES	1970-01-01 01:00:00.000000000 +0100
+++ ./CHANGES	2014-02-17 09:30:53.000000000 +0100
@@ -0,0 +1 @@
+none

diff -urN ../calc-3.1/LIBRARY ./LIBRARY
--- ../calc-3.1/LIBRARY	1970-01-01 01:00:00.000000000 +0100
+++ ./LIBRARY	2014-02-17 09:28:41.000000000 +0100
@@ -0,0 +1,3 @@
+	USING THE ARBITRARY PRECISION ROUTINES IN A C PROGRAM
+To be written...
+

diff -urN ../calc-3.1/Makefile ./Makefile
--- ../calc-3.1/Makefile	2009-08-01 06:13:21.000000000 +0200
+++ ./Makefile	2014-02-17 08:37:18.000000000 +0100
@@ -1279,8 +1279,8 @@
 #
 LIB_H_SRC= alloc.h blkcpy.h block.h byteswap.h calc.h cmath.h \
 	config.h custom.h file.h hash.h hist.h jump.h \
-	label.h lib_util.h math_error.h md5.h nametype.h \
-	opcodes.h prime.h qmath.h shs.h shs1.h string.h \
+	lib_util.h math_error.h md5.h nametype.h \
+	prime.h qmath.h shs.h shs1.h string.h \
 	symbol.h token.h value.h win32dll.h zmath.h zrand.h zrandom.h

 # we build these .h files during the make
diff -urN ../calc-3.1/builtinfunc.c ./builtinfunc.c
--- ../calc-3.1/builtinfunc.c	2009-08-01 06:59:36.000000000 +0200
+++ ./builtinfunc.c	2014-02-17 09:19:50.000000000 +0100
@@ -642,7 +642,28 @@
 	 NULL}
 };

+#if defined(FUNCLIST)
+/*ARGSUSED*/
+int
+main(int argc, char *argv[])
+{
+        CONST BuiltinFuncInfo *bp;       /* current function */

+        printf("\nName\tArgs\tDescription\n\n");
+        for (bp = builtins; bp->name; bp++) {
+                printf("%-9s ", bp->name);
+                if (bp->maxArgs == IN)
+                        printf("%d+    ", bp->minArgs);
+                else if (bp->minArgs == bp->maxArgs)
+                        printf("%-6d", bp->minArgs);
+                else
+                        printf("%d-%-4d", bp->minArgs, bp->maxArgs);
+                printf("%s\n", bp->desc);
+        }
+        printf("\n");
+        return 0;       /* exit(0); */
+}
+#else /* FUNCLIST */
 /*
  * Show the list of primitive built-in functions
  *
@@ -679,7 +700,7 @@

 	printf("\n");
 }
-
+#endif /* FUNCLIST */

 #if !defined(FUNCLIST)

diff -urN ../calc-3.1/help/Makefile ./help/Makefile
--- ../calc-3.1/help/Makefile	2003-01-14 03:24:58.000000000 +0100
+++ ./help/Makefile	2014-02-17 09:21:54.000000000 +0100
@@ -162,7 +162,7 @@
 # standard tools
 #
 LCC= cc
-ICFLAGS=
+ICFLAGS=-DCALC_SRC
 ILDFLAGS=
 CHMOD= chmod
 SED= sed
@@ -533,7 +533,7 @@
 builtin: builtin.top builtin.end ../func.c funclist.sed
 	${Q}echo "forming builtin help file"
 	-${Q}rm -f funclist.c
-	${Q}${SED} -n -f funclist.sed ../func.c > funclist.c
+	${Q}${SED} -n -f funclist.sed ../builtinfunc.c > funclist.c
 	-${Q}rm -f funclist.o funclist
 	${Q}${LCC} ${ICFLAGS} -DFUNCLIST -I/usr/include \
 	    -I.. funclist.c -c 2>/dev/null


diff -urN ../calc-3.1/execute.c ./execute.c
--- ../calc-3.1/execute.c	2009-08-01 07:00:43.000000000 +0200
+++ ./execute.c	2014-02-17 09:41:30.000000000 +0100
@@ -2764,3 +2764,127 @@
 	while (currentFuncState != 0)
 		FreeFunction();
 }
+
+/*
+ * Generate and throw an error value.
+ * The error is saved in a static location for later examination.
+ */
+void
+BuildAndThrowError(int type, long code, const char * message)
+{
+	Error * error = AllocError(type, code, message);
+
+	ThrowError(error);
+}
+
+
+/*
+ * Throw a previously built error.
+ * The error is saved in a static location for later examination.
+ */
+void
+ThrowError(const Error * error)
+{
+	const char *	functionName;
+	int		lineNumber;
+
+	/*
+	 * If we are tracing exceptions then display that.
+	 */
+	if (conf->traceflags & TRACE_ERRORS)
+	{
+		/*
+		 * Get the throwing function name and line number if possible.
+		 */
+		functionName = GetFunctionName();
+		lineNumber = GetFunctionLineNumber();
+
+		if ((functionName == 0) || (*functionName == '\0'))
+		{
+			TraceFilePrintf("EXCEPTION: Throw: %s\n",
+				GetErrorMessage(error));
+		}
+		else
+		{
+			TraceFilePrintf(
+				"EXCEPTION: Throw at \"%s\", line %d: %s\n",
+				functionName, lineNumber,
+				GetErrorMessage(error));
+		}
+	}
+
+	/*
+	 * Save the error for examination later.
+	 */
+	SaveCurrentError((Error *) error);
+
+	/*
+	 * If we can, then jump away to handle the error.
+	 */
+	if (post_init)
+	{
+		/*
+		 * Try to let the currently running function handle the error.
+		 * If the exception is handled, then this call won't return.
+		 * It it won't handle it, then the call will return.
+		 */
+		HandleFunctionException();
+	}
+
+	/*
+	 * Throw the error to the top level.
+	 */
+	ThrowTopLevelError(error);
+}
+
+
+/*
+ * Handle a top level error.
+ * This will immediately longjmp back to the top level of the
+ * calculator (if possible) without calling any CATCH blocks.
+ */
+void
+ThrowTopLevelError(const Error * error)
+{
+	/*
+	 * If we are tracing exceptions then describe this.
+	 */
+	if (conf->traceflags & TRACE_ERRORS)
+		TraceFilePrintf("EXCEPTION: Calling top level error handler\n");
+
+	/*
+	 * Save the current error if it hasn't already been saved.
+	 */
+	SaveCurrentError((Error *) error);
+
+	/*
+	 * If we have been inited then print the error and jump
+	 * back to the top level code.
+	 */
+	if (post_init)
+	{
+		/*
+		 * Say we are handling the error.
+		 */
+		math_cleardiversions();
+		PrintError(error, PRINT_NORMAL);
+		math_str("\n");
+		math_flush();
+
+		longjmp(jmpbuf, 1);
+	}
+
+	/*
+	 * We are not prepared to handle the error, and so must exit.
+	 */
+	fprintf(stderr, "Error: %s\n", GetErrorMessage(error));
+
+	fprintf(stderr, "It is too early provide a command line prompt "
+			"so we must simply exit.  Sorry!\n");
+
+	/*
+	 * don't call libcalc_call_me_last() -- we might loop
+	 * and besides ... this is an unusual internal error case
+	 */
+	exit(3);
+}

--- ../calc-3.1/calc.c	2014-02-17 09:33:17.000000000 +0100
+++ calc.c	2014-02-17 09:46:00.000000000 +0100
@@ -748,132 +748,6 @@
 	BuildAndThrowError(ERROR_TYPE_BUILTIN, 0, buf);
 }
 
-
-/*
- * Generate and throw an error value.
- * The error is saved in a static location for later examination.
- */
-void
-BuildAndThrowError(int type, long code, const char * message)
-{
-	Error * error = AllocError(type, code, message);
-
-	ThrowError(error); 
-}
-
-
-/*
- * Throw a previously built error.
- * The error is saved in a static location for later examination.
- */ 
-void
-ThrowError(const Error * error)
-{
-	const char *	functionName;
-	int		lineNumber;
-
-	/*
-	 * If we are tracing exceptions then display that.
-	 */
-	if (conf->traceflags & TRACE_ERRORS)
-	{
-		/*
-		 * Get the throwing function name and line number if possible.
-		 */
-		functionName = GetFunctionName();
-		lineNumber = GetFunctionLineNumber();
-
-		if ((functionName == 0) || (*functionName == '\0'))
-		{
-			TraceFilePrintf("EXCEPTION: Throw: %s\n",
-				GetErrorMessage(error));
-		}
-		else
-		{
-			TraceFilePrintf(
-				"EXCEPTION: Throw at \"%s\", line %d: %s\n",
-				functionName, lineNumber,
-				GetErrorMessage(error));
-		}
-	}
-
-	/*
-	 * Save the error for examination later.
-	 */
-	SaveCurrentError((Error *) error);
-
-	/*
-	 * If we can, then jump away to handle the error.
-	 */
-	if (post_init)
-	{
-		/*
-		 * Try to let the currently running function handle the error.
-		 * If the exception is handled, then this call won't return.
-		 * It it won't handle it, then the call will return.
-		 */
-		HandleFunctionException();
-	}
-
-	/*
-	 * Throw the error to the top level.
-	 */
-	ThrowTopLevelError(error);
-}
-
-
-/*
- * Handle a top level error.
- * This will immediately longjmp back to the top level of the
- * calculator (if possible) without calling any CATCH blocks.
- */
-void
-ThrowTopLevelError(const Error * error)
-{
-	/*
-	 * If we are tracing exceptions then describe this.
-	 */
-	if (conf->traceflags & TRACE_ERRORS)
-		TraceFilePrintf("EXCEPTION: Calling top level error handler\n");
-
-	/*
-	 * Save the current error if it hasn't already been saved.
-	 */
-	SaveCurrentError((Error *) error);
-
-	/*
-	 * If we have been inited then print the error and jump
-	 * back to the top level code.
-	 */
-	if (post_init)
-	{
-		/*
-		 * Say we are handling the error.
-		 */
-		math_cleardiversions();
-		PrintError(error, PRINT_NORMAL);
-		math_str("\n");
-		math_flush();
-
-		longjmp(jmpbuf, 1);
-	}
-
-	/*
-	 * We are not prepared to handle the error, and so must exit.
-	 */
-	fprintf(stderr, "Error: %s\n", GetErrorMessage(error));
-
-	fprintf(stderr, "It is too early provide a command line prompt "
-			"so we must simply exit.  Sorry!\n");
-
-	/*
-	 * don't call libcalc_call_me_last() -- we might loop
-	 * and besides ... this is an unusual internal error case
-	 */
-	exit(3);
-}
-
-
 static int
 nextcp(char **cpp, int *ip, int argc, char **argv, BOOL haveendstr)
 {
