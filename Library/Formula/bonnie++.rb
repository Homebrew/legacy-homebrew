require 'formula'

class Bonniexx < Formula
  homepage 'http://www.coker.com.au/bonnie++/'
  url 'http://www.coker.com.au/bonnie++/experimental/bonnie++-1.97.tgz'
  sha1 '7b0ed205725a6526d34894412edb7e29bb9df7b4'

  # Fix use of min/max with clang
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end

__END__
diff --git a/bonnie++.cpp b/bonnie++.cpp
index 8c5a43a..7fc86f7 100644
--- a/bonnie++.cpp
+++ b/bonnie++.cpp
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
 
@@ -393,8 +393,8 @@ int main(int argc, char *argv[])
     usage();
   }
 #endif
-  globals.byte_io_size = __min(file_size, globals.byte_io_size);
-  globals.byte_io_size = __max(0, globals.byte_io_size);
+  globals.byte_io_size = min(file_size, globals.byte_io_size);
+  globals.byte_io_size = max(0, globals.byte_io_size);
 
   if(machine == NULL)
   {
diff --git a/duration.cpp b/duration.cpp
index efa3fd3..f943155 100644
--- a/duration.cpp
+++ b/duration.cpp
@@ -38,7 +38,7 @@ double Duration_Base::stop()
   getTime(&tv);
   double ret;
   ret = tv - m_start;
-  m_max = __max(m_max, ret);
+  m_max = max(m_max, ret);
   return ret;
 }
 
diff --git a/port.h b/port.h
index 8d53622..2e1f112 100644
--- a/port.h
+++ b/port.h
@@ -49,8 +49,6 @@ typedef struct timeval TIMEVAL_TYPE;
 #endif
 
 typedef int FILE_TYPE;
-#define __min min
-#define __max max
 typedef unsigned int UINT;
 typedef unsigned long ULONG;
 typedef const char * PCCHAR;
diff --git a/Makefile b/Makefile
index 4bb5103..8f7ed41 100644
--- a/Makefile
+++ b/Makefile
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
diff --git a/port.h.in b/port.h.in
index 69c8f24..8359d72 100644
--- a/port.h.in
+++ b/port.h.in
@@ -49,8 +49,6 @@ typedef struct timeval TIMEVAL_TYPE;
 #endif
 
 typedef int FILE_TYPE;
-#define __min min
-#define __max max
 typedef unsigned int UINT;
 typedef unsigned long ULONG;
 typedef const char * PCCHAR;
