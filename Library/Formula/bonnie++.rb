class Bonniexx < Formula
  desc "Benchmark suite for file systems and hard drives"
  homepage "http://www.coker.com.au/bonnie++/"
  url "http://www.coker.com.au/bonnie++/experimental/bonnie++-1.97.tgz"
  sha256 "44f5a05937648a6526ba99354555d7d15f2dd392e55d3436f6746da6f6c35982"

  bottle do
    cellar :any
    sha1 "92516b5595cecc77d56bcf908625e09b26f094d9" => :yosemite
    sha1 "c1f228e5344318c848ac96b9e9a6e451d043faf8" => :mavericks
    sha1 "201190cf5f4783a63c743163040da9ed6978d53a" => :mountain_lion
  end

  # Fix use of min/max with clang
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end

# Changes included in this patchset:
# 1) Explicitly use clang/clang++ in Makefile
# 2) __min() and __max() macros break bon_csv2html.cpp: "redefinition of 'min' as different kind of symbol"
#    Remove the construct in favor of macro targets min()/max() provided by the library
#    Files affected: port.h.in port.h duration.cpp bonnie++.cpp
# 3) Remove the #ifdef _LARGEFILE64_SOURCE macros which not only prohibits the intended functionality of
#    splitting into 2 GB files for such filesystems but also incorrectly tests for it in the first place.
#    The ideal fix would be to replace the AC_TRY_RUN() in configure.in if the fail code actually worked.
#    Files affected: bonnie++.cp

__END__
diff --git i/Makefile w/Makefile
index 4bb5103..8f7ed41 100644
--- i/Makefile
+++ w/Makefile
@@ -10,8 +10,8 @@ eprefix=${prefix}
 #MORE_WARNINGS=-Weffc++
 WFLAGS=-Wall -W -Wshadow -Wpointer-arith -Wwrite-strings -pedantic -ffor-scope -Wcast-align -Wsign-compare -Wpointer-arith -Wwrite-strings -Wformat-security -Wswitch-enum -Winit-self $(MORE_WARNINGS)
 CFLAGS=-O2  -DNDEBUG $(WFLAGS) $(MORECFLAGS)
-CXX=g++ $(CFLAGS)
-LINK=g++
+CXX=clang++ $(CFLAGS)
+LINK=clang++
 THREAD_LFLAGS=-lpthread

 INSTALL=/usr/bin/install -c
diff --git i/bonnie++.cpp w/bonnie++.cpp
index 8c5a43a..8a4b3dc 100644
--- i/bonnie++.cpp
+++ w/bonnie++.cpp
@@ -73,7 +73,7 @@ public:
   void set_io_chunk_size(int size)
     { delete m_buf; pa_new(size, m_buf, m_buf_pa); m_io_chunk_size = size; }
   void set_file_chunk_size(int size)
-    { delete m_buf; m_buf = new char[__max(size, m_io_chunk_size)]; m_file_chunk_size = size; }
+    { delete m_buf; m_buf = new char[max(size, m_io_chunk_size)]; m_file_chunk_size = size; }
 
   // Return the page-aligned version of the local buffer
   char *buf() { return m_buf_pa; }
@@ -138,7 +138,7 @@ CGlobalItems::CGlobalItems(bool *exitFlag)
  , m_buf(NULL)
  , m_buf_pa(NULL)
 {
-  pa_new(__max(m_io_chunk_size, m_file_chunk_size), m_buf, m_buf_pa);
+  pa_new(max(m_io_chunk_size, m_file_chunk_size), m_buf, m_buf_pa);
   SetName(".");
 }
 
@@ -294,11 +294,7 @@ int main(int argc, char *argv[])
       {
         char *sbuf = _strdup(optarg);
         char *size = strtok(sbuf, ":");
-#ifdef _LARGEFILE64_SOURCE
         file_size = size_from_str(size, "gt");
-#else
-        file_size = size_from_str(size, "g");
-#endif
         size = strtok(NULL, "");
         if(size)
         {
@@ -384,17 +380,8 @@ int main(int argc, char *argv[])
     if(file_size % 1024 > 512)
       file_size = file_size + 1024 - (file_size % 1024);
   }
-#ifndef _LARGEFILE64_SOURCE
-  if(file_size == 2048)
-    file_size = 2047;
-  if(file_size > 2048)
-  {
-    fprintf(stderr, "Large File Support not present, can't do %dM.\n", file_size);
-    usage();
-  }
-#endif
-  globals.byte_io_size = __min(file_size, globals.byte_io_size);
-  globals.byte_io_size = __max(0, globals.byte_io_size);
+  globals.byte_io_size = min(file_size, globals.byte_io_size);
+  globals.byte_io_size = max(0, globals.byte_io_size);
 
   if(machine == NULL)
   {
@@ -465,14 +452,6 @@ int main(int argc, char *argv[])
      && (directory_max_size < directory_min_size || directory_max_size < 0
      || directory_min_size < 0) )
     usage();
-#ifndef _LARGEFILE64_SOURCE
-  if(file_size > (1 << (31 - 20 + globals.io_chunk_bits)) )
-  {
-    fprintf(stderr
-   , "The small chunk size and large IO size make this test impossible in 32bit.\n");
-    usage();
-  }
-#endif
   if(file_size && globals.ram && (file_size * concurrency) < (globals.ram * 2) )
   {
     fprintf(stderr
diff --git i/duration.cpp w/duration.cpp
index efa3fd3..f943155 100644
--- i/duration.cpp
+++ w/duration.cpp
@@ -38,7 +38,7 @@ double Duration_Base::stop()
   getTime(&tv);
   double ret;
   ret = tv - m_start;
-  m_max = __max(m_max, ret);
+  m_max = max(m_max, ret);
   return ret;
 }
 
diff --git i/port.h w/port.h
index 8d53622..2e1f112 100644
--- i/port.h
+++ w/port.h
@@ -49,8 +49,6 @@ typedef struct timeval TIMEVAL_TYPE;
 #endif
 
 typedef int FILE_TYPE;
-#define __min min
-#define __max max
 typedef unsigned int UINT;
 typedef unsigned long ULONG;
 typedef const char * PCCHAR;
diff --git i/port.h.in w/port.h.in
index 69c8f24..8359d72 100644
--- i/port.h.in
+++ w/port.h.in
@@ -49,8 +49,6 @@ typedef struct timeval TIMEVAL_TYPE;
 #endif
 
 typedef int FILE_TYPE;
-#define __min min
-#define __max max
 typedef unsigned int UINT;
 typedef unsigned long ULONG;
 typedef const char * PCCHAR;
