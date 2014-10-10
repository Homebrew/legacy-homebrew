require "formula"

class FollyMinimal < Formula
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/5617e556f7b806027b0105996a8f1f45ea294d49.tar.gz"
  version "11.0"
  sha1 "660af9ca8423bd1870a91bbe4c64c7fa7a40bcbd"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "gflags"
  depends_on "glog"
  depends_on "boost"
  depends_on "libevent"
  depends_on "lz4"
  depends_on "snappy"
  depends_on "jemalloc"
  depends_on "double-conversion"

  def install
    cd "folly"

    # Remove the headers at compile-time so we can be sure they're actually
    # unused. Otherwise, a compile might succeed, but the headers won't be
    # installed causing failures for projects that use us.
    # Except the test ones.
    system "rm",
        * %w{
          Benchmark.h detail/Futex.h detail/MemoryIdler.h
          experimental/Bits.h experimental/EliasFanoCoding.h
          experimental/EventCount.h experimental/io/FsUtil.h
          experimental/TestUtil.h experimental/wangle/concurrent/Codel.h
          experimental/wangle/ConnectionManager.h
          experimental/wangle/ManagedConnection.h
          io/Compression.h LifoSem.h Subprocess.h
          wangle/Executor.h wangle/Future-inl.h wangle/Future.h
          wangle/GenericThreadGate.h wangle/InlineExecutor.h wangle/Later-inl.h
          wangle/Later.h wangle/ManualExecutor.h wangle/Promise-inl.h
          wangle/Promise.h wangle/ThreadGate.h wangle/Try-inl.h wangle/Try.h
          wangle/WangleException.h wangle/detail/State.h
        }

    system "autoreconf", "-i"

    system "./configure",
        "--disable-dependency-tracking",
        "--with-boost-thread=boost_thread-mt",
        "--with-boost-regex=boost_regex-mt",
        "--with-boost-system=boost_system-mt",
        "--with-boost-filesystem=boost_filesystem-mt",
        "--prefix=#{prefix}"

    system "make", "install"
  end

  patch :p0, :DATA
end

__END__
diff -ru folly/Makefile.am folly/Makefile.am
--- folly/Makefile.am	2014-10-09 12:01:47.000000000 -0700
+++ folly/Makefile.am	2014-10-10 12:53:36.000000000 -0700
@@ -4,16 +4,11 @@
 
 CLEANFILES =
 
-noinst_PROGRAMS = generate_fingerprint_tables
-generate_fingerprint_tables_SOURCES = build/GenerateFingerprintTables.cpp
-generate_fingerprint_tables_LDADD = libfollybase.la
-
 noinst_LTLIBRARIES = \
 	libfollybase.la
 
 lib_LTLIBRARIES = \
-	libfolly.la \
-	libfollybenchmark.la
+	libfolly.la
 
 follyincludedir = $(includedir)/folly
 
@@ -28,7 +23,6 @@
 	AtomicHashMap-inl.h \
 	AtomicStruct.h \
 	Baton.h \
-	Benchmark.h \
 	Bits.h \
 	Checksum.h \
 	Chrono.h \
@@ -42,12 +36,10 @@
 	detail/ExceptionWrapper.h \
 	detail/FileUtilDetail.h \
 	detail/FingerprintPolynomial.h \
 	detail/FunctionalExcept.h \
-	detail/Futex.h \
 	detail/GroupVarintDetail.h \
 	detail/IPAddress.h \
 	detail/Malloc.h \
-	detail/MemoryIdler.h \
 	detail/MPMCPipelineDetail.h \
 	detail/SlowFingerprint.h \
 	detail/Stats.h \
@@ -66,14 +56,6 @@
 	Exception.h \
 	ExceptionWrapper.h \
 	EvictingCacheMap.h \
-	experimental/Bits.h \
-	experimental/EliasFanoCoding.h \
-	experimental/EventCount.h \
-	experimental/io/FsUtil.h \
-	experimental/TestUtil.h \
-	experimental/wangle/concurrent/Codel.h \
-	experimental/wangle/ConnectionManager.h \
-	experimental/wangle/ManagedConnection.h \
 	FBString.h \
 	FBVector.h \
 	File.h \
@@ -106,7 +88,6 @@
 	IPAddressException.h \
 	IndexedMemPool.h \
 	IntrusiveList.h \
-	io/Compression.h \
 	io/Cursor.h \
 	io/IOBuf.h \
 	io/IOBufQueue.h \
@@ -125,7 +106,6 @@
 	io/async/TimeoutManager.h \
 	json.h \
 	Lazy.h \
-	LifoSem.h \
 	Likely.h \
 	Logging.h \
 	MacAddress.h \
@@ -161,12 +141,7 @@
 	stats/MultiLevelTimeSeries.h \
 	String.h \
 	String-inl.h \
-	Subprocess.h \
 	Synchronized.h \
-	test/FBStringTestBenchmarks.cpp.h \
-	test/FBVectorTestBenchmarks.cpp.h \
-	test/function_benchmark/benchmark_impl.h \
-	test/function_benchmark/test_functions.h \
 	test/SynchronizedTestLib.h \
 	test/SynchronizedTestLib-inl.h \
 	ThreadCachedArena.h \
@@ -179,22 +154,7 @@
 	Uri.h \
 	Uri-inl.h \
 	Varint.h \
-	VersionCheck.h \
-	wangle/Executor.h \
-	wangle/Future-inl.h \
-	wangle/Future.h \
-	wangle/GenericThreadGate.h \
-	wangle/InlineExecutor.h \
-	wangle/Later-inl.h \
-	wangle/Later.h \
-	wangle/ManualExecutor.h \
-	wangle/Promise-inl.h \
-	wangle/Promise.h \
-	wangle/ThreadGate.h \
-	wangle/Try-inl.h \
-	wangle/Try.h \
-	wangle/WangleException.h \
-	wangle/detail/State.h
+	VersionCheck.h
 
 FormatTables.cpp: build/generate_format_tables.py
 	build/generate_format_tables.py
@@ -225,15 +185,11 @@
 	dynamic.cpp \
 	File.cpp \
 	FileUtil.cpp \
-	FingerprintTables.cpp \
-	detail/Futex.cpp \
 	GroupVarint.cpp \
 	GroupVarintTables.cpp \
 	IPAddress.cpp \
 	IPAddressV4.cpp \
 	IPAddressV6.cpp \
-	LifoSem.cpp \
-	io/Compression.cpp \
 	io/IOBuf.cpp \
 	io/IOBufQueue.cpp \
 	io/RecordIO.cpp \
@@ -243,7 +199,6 @@
 	io/async/Request.cpp \
 	io/async/HHWheelTimer.cpp \
 	json.cpp \
-	detail/MemoryIdler.cpp \
 	MacAddress.cpp \
 	MemoryMapping.cpp \
 	Random.cpp \
@@ -252,19 +207,10 @@
 	SpookyHashV1.cpp \
 	SpookyHashV2.cpp \
 	stats/Instantiations.cpp \
-	Subprocess.cpp \
 	ThreadCachedArena.cpp \
 	TimeoutQueue.cpp \
 	Uri.cpp \
-	Version.cpp \
-	wangle/InlineExecutor.cpp \
-	wangle/ManualExecutor.cpp \
-	wangle/ThreadGate.cpp \
-	experimental/io/FsUtil.cpp \
-	experimental/TestUtil.cpp \
-	experimental/wangle/concurrent/Codel.cpp \
-	experimental/wangle/ConnectionManager.cpp \
-	experimental/wangle/ManagedConnection.cpp
+	Version.cpp
 
 if HAVE_LINUX
 nobase_follyinclude_HEADERS += \
@@ -273,28 +219,21 @@
 	experimental/io/HugePages.cpp
 endif
 
 if !HAVE_LINUX
 nobase_follyinclude_HEADERS += detail/Clock.h
 libfollybase_la_SOURCES += detail/Clock.cpp
 endif
 
 if !HAVE_WEAK_SYMBOLS
 libfollybase_la_SOURCES += detail/MallocImpl.cpp
 endif
 
 if !HAVE_BITS_FUNCTEXCEPT
 libfollybase_la_SOURCES += detail/FunctionalExcept.cpp
 endif
 
 libfollybase_la_LDFLAGS = $(AM_LDFLAGS) -version-info $(LT_VERSION)
 
 libfolly_la_LIBADD = libfollybase.la
 libfolly_la_LDFLAGS = $(AM_LDFLAGS) -version-info $(LT_VERSION)
 
-FingerprintTables.cpp: generate_fingerprint_tables
-	./generate_fingerprint_tables
-CLEANFILES += FingerprintTables.cpp
-
-libfollybenchmark_la_SOURCES = Benchmark.cpp
-libfollybenchmark_la_LIBADD = libfolly.la
-libfollybenchmark_la_LDFLAGS = $(AM_LDFLAGS) -version-info $(LT_VERSION)
diff -ru folly/SocketAddress.h folly/SocketAddress.h
--- folly/SocketAddress.h	2014-10-09 12:01:47.000000000 -0700
+++ folly/SocketAddress.h	2014-10-10 12:38:17.000000000 -0700
@@ -20,7 +20,9 @@
 #include <sys/socket.h>
 #include <sys/un.h>
 #include <netinet/in.h>
-#include <features.h>
+#ifdef HAVE_FEATURES_H
+# include <features.h>
+#endif
 #include <netdb.h>
 #include <cstddef>
 #include <iostream>
