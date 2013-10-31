require 'formula'

class Pure < Formula
  homepage 'http://purelang.bitbucket.org/'
  url 'https://bitbucket.org/purelang/pure-lang/downloads/pure-0.57.tar.gz'
  sha1 '5c7441993752d0e2cba74912521d6df865e5dc0b'

  # Autotools are needed due to patching configure.ac. Remove on new releases.
  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  depends_on 'llvm'
  depends_on 'gmp'
  depends_on 'readline'
  depends_on 'mpfr'

  resource 'docs' do
    url 'https://bitbucket.org/purelang/pure-lang/downloads/pure-docs-0.57.tar.gz'
    sha1 '7f2c6051b831d3de887f2182e8b29b1716ab45fd'
  end

  # Patches backported from trunk for llvm 3.3 compatibility. Originally:
  # https://bitbucket.org/purelang/pure-lang/commits/2866a677f3362ccfd0ced24b9dd235bff627f4c5/raw/
  # removing changes to ChangeLog to apply.
  def patches
    {
      :p2 => [
        DATA,
        'https://bitbucket.org/purelang/pure-lang/commits/387a67f2f9943640c05b3e8d796ddf7f06febe3f/raw/'
      ]
    }
  end

  def install
    # Force regenerate configure/Makefile due to patching
    # configure.ac. Remove when new release is available.
    system "autoreconf -fiv"

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-release",
                          "--without-elisp"
    system "make"
    system "make check"
    system "make install"
    resource('docs').stage { system "make", "prefix=#{prefix}", "install" }
  end
end

__END__
# HG changeset patch
# User Albert Graef <Dr.Graef@t-online.de>
# Date 1376480012 -7200
# Node ID 2866a677f3362ccfd0ced24b9dd235bff627f4c5
# Parent  356f97c14d61d49431c622e2ee1ece4bdc1fab54
LLVM 3.3 compatibility fixes.

diff --git a/pure/configure.ac b/pure/configure.ac
--- a/pure/configure.ac
+++ b/pure/configure.ac
@@ -321,6 +321,17 @@
 AC_LANG_PUSH([C++])
 save_CPPFLAGS=$CPPFLAGS
 CPPFLAGS="`$LLVMCONF --cppflags` $CPPFLAGS"
+AC_CACHE_CHECK([for new LLVM IRBuilder class (LLVM >= 3.3)], [pure_cv_new_builder33],
+  [AC_COMPILE_IFELSE([AC_LANG_PROGRAM([
+       #include <llvm/IR/IRBuilder.h>
+      ], [
+        llvm::IRBuilder<> b(llvm::getGlobalContext());
+      ])
+    ], [pure_cv_new_builder33=yes], [pure_cv_new_builder33=no])
+  ])
+if test "$pure_cv_new_builder33" = yes; then
+pure_cv_new_builder26=yes
+else
 AC_CACHE_CHECK([for new LLVM IRBuilder class (LLVM >= 3.2)], [pure_cv_new_builder32],
   [AC_COMPILE_IFELSE([AC_LANG_PROGRAM([
        #include <llvm/IRBuilder.h>
@@ -342,6 +353,7 @@
     ], [pure_cv_new_builder26=yes], [pure_cv_new_builder26=no])
   ])
 fi
+fi
 if test "$pure_cv_new_builder26" = yes; then
   AC_DEFINE(NEW_BUILDER, 1, [Define when building with new-style LLVM IRBuilder template class.])
   AC_DEFINE(LLVM26, 1, [Define when building with new-style LLVM API (LLVM 2.6 or later).])
@@ -372,7 +384,7 @@
 fi
 fi
 AC_CHECK_HEADERS([llvm/Support/DynamicLibrary.h], [], [], [[#include <llvm/ADT/StringRef.h>]])
-AC_CHECK_HEADERS([llvm/Support/raw_ostream.h llvm/Support/raw_os_ostream.h llvm/ModuleProvider.h llvm/TypeSymbolTable.h llvm/DataLayout.h llvm/IRBuilder.h llvm/Support/TargetSelect.h])
+AC_CHECK_HEADERS([llvm/Support/raw_ostream.h llvm/Support/raw_os_ostream.h llvm/ModuleProvider.h llvm/TypeSymbolTable.h llvm/DataLayout.h llvm/IR/DataLayout.h llvm/DerivedTypes.h llvm/IRBuilder.h llvm/IR/IRBuilder.h llvm/Support/TargetSelect.h])
 if test "$pure_cv_new_builder26" = yes; then
   AC_CHECK_DECLS([llvm::PerformTailCallOpt, llvm::GuaranteedTailCallOpt], [], [], [[#include <llvm/ADT/StringRef.h>
 #include <llvm/Target/TargetOptions.h>]])
diff --git a/pure/interpreter.cc b/pure/interpreter.cc
--- a/pure/interpreter.cc
+++ b/pure/interpreter.cc
@@ -47,7 +47,11 @@
 #include <fnmatch.h>
 #include <glob.h>
 
+#if LLVM33
+#include <llvm/IR/CallingConv.h>
+#else
 #include <llvm/CallingConv.h>
+#endif
 #include <llvm/PassManager.h>
 #include <llvm/Support/CallSite.h>
 #include <llvm/Transforms/Utils/BasicBlockUtils.h>
diff --git a/pure/interpreter.hh b/pure/interpreter.hh
--- a/pure/interpreter.hh
+++ b/pure/interpreter.hh
@@ -19,12 +19,20 @@
 #ifndef INTERPRETER_HH
 #define INTERPRETER_HH
 
+#ifdef HAVE_LLVM_DERIVEDTYPES_H
+// LLVM 3.3 and later have these headers in a different directory.
 #include <llvm/DerivedTypes.h>
+#include <llvm/Module.h>
+#include <llvm/GlobalValue.h>
+#else
+#include <llvm/IR/DerivedTypes.h>
+#include <llvm/IR/Module.h>
+#include <llvm/IR/GlobalValue.h>
+#endif
+
 #include <llvm/ExecutionEngine/ExecutionEngine.h>
 #include <llvm/ExecutionEngine/JIT.h>
-#include <llvm/Module.h>
 #include <llvm/PassManager.h>
-#include <llvm/GlobalValue.h>
 #include <llvm/Analysis/Verifier.h>
 #include <llvm/Target/TargetOptions.h>
 #include <llvm/Transforms/Scalar.h>
@@ -42,15 +50,25 @@
 #include <llvm/DataLayout.h>
 #define LLVM32 1
 #else
+#ifdef HAVE_LLVM_IR_DATALAYOUT_H
+#include <llvm/IR/DataLayout.h>
+#define LLVM32 1
+#define LLVM33 1
+#else
 #include <llvm/Target/TargetData.h>
 #endif
+#endif
 
 #ifdef HAVE_LLVM_IRBUILDER_H
 // LLVM 3.2 and later have this header in a different directory.
 #include <llvm/IRBuilder.h>
 #else
+#ifdef HAVE_LLVM_IR_IRBUILDER_H
+#include <llvm/IR/IRBuilder.h>
+#else
 #include <llvm/Support/IRBuilder.h>
 #endif
+#endif
 
 #ifdef HAVE_LLVM_MODULEPROVIDER_H
 #include <llvm/ModuleProvider.h>
@@ -75,8 +93,12 @@
 #endif
 
 #if LLVM26
+#if LLVM33
+#include "llvm/IR/LLVMContext.h"
+#else
 #include "llvm/LLVMContext.h"
 #endif
+#endif
 
 #include "parserdefs.hh"
 // Get rid of silly warnings in bison-generated position.hh.
diff --git a/pure/runtime.cc b/pure/runtime.cc
--- a/pure/runtime.cc
+++ b/pure/runtime.cc
@@ -15397,7 +15397,6 @@
   pure_ref(f);
   pure_ref(x);
 
-  typedef typename element_of<matrix_type>::type elem_type;
   matrix_type *xm = static_cast<matrix_type*>(x->data.mat.p);
   size_t lasti,lastj;
   pure_expr *out; //result matrix
@@ -15666,7 +15665,6 @@
   pure_ref(f);
   pure_ref(x);
 
-  typedef typename element_of<matrix_type>::type elem_type;
   matrix_type *xm = static_cast<matrix_type*>(x->data.mat.p);
   ptrdiff_t lasti,lastj;
   pure_expr *out; //result matrix
