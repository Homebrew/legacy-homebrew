require 'formula'

class Szl < Formula
  homepage 'http://code.google.com/p/szl/'
  url 'https://szl.googlecode.com/files/szl-1.0.tar.gz'
  sha1 'e4c6d4aec1afc025257d41dd77b8f5c25ea120d4'

  depends_on 'binutils' # For objdump
  depends_on 'icu4c'
  depends_on 'protobuf'
  depends_on 'pcre'

  # 10.9 and clang fixes
  # Include reported upstream in:
  # https://code.google.com/p/szl/issues/detail?id=28
  # Clang issue reported upstream in:
  # https://code.google.com/p/szl/issues/detail?id=34
  patch :DATA

  def install
    ENV['OBJDUMP'] = "#{HOMEBREW_PREFIX}/bin/gobjdump"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/src/utilities/random_base.cc b/src/utilities/random_base.cc
index 1d64521..e488321 100644
--- a/src/utilities/random_base.cc
+++ b/src/utilities/random_base.cc
@@ -18,6 +18,7 @@
 #include <string>
 #include <memory.h>
 #include <assert.h>
+#include <unistd.h>
 
 #include "public/porting.h"
 #include "public/logging.h"
diff --git a/src/engine/code.cc b/src/engine/code.cc
index d149f9a..75ab84b 100644
--- a/src/engine/code.cc
+++ b/src/engine/code.cc
@@ -18,6 +18,7 @@
 #include <string>
 #include <errno.h>
 #include <sys/mman.h>
+#include <unistd.h>
 
 #include "engine/globals.h"
 #include "public/logging.h"
diff --git a/src/engine/symboltable.cc b/src/engine/symboltable.cc
index 6d84592..71965f3 100644
--- a/src/engine/symboltable.cc
+++ b/src/engine/symboltable.cc
@@ -44,7 +44,7 @@ namespace sawzall {
 // ------------------------------------------------------------------------------
 // Implementation of SymbolTable
 
-Proc::Proc* SymbolTable::init_proc_ = NULL;
+Proc* SymbolTable::init_proc_ = NULL;
 
 List<TableType*>* SymbolTable::table_types_ = NULL;
 TableType* SymbolTable::collection_type_ = NULL;
