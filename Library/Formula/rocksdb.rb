class Rocksdb < Formula
  desc "Persistent key-value store for fast storage environments"
  homepage "http://rocksdb.org"
  url "https://github.com/facebook/rocksdb/archive/rocksdb-3.12.tar.gz"
  sha256 "2f50f134572d97f0f00f7bb3582ce22ad82e3f0281f3736bc87237fc5a1c02e6"

  bottle do
    cellar :any
    revision 1
    sha256 "9f5e064a29837a8aef87a8ebe2d9b576f9881fa669e085f7518b8344c5bc39ab" => :yosemite
    sha256 "7e2bf1f95f49c4d5f111737d171fd333e3a6d89a435d74f76163d1b1291a6138" => :mavericks
    sha256 "ada906d1b4fa26f73ce3aa4b393c6c9d7ec76bf50663e2ff748d143f6c3518bc" => :mountain_lion
  end

  option "with-lite", "Build mobile/non-flash optimized lite version"

  needs :cxx11
  depends_on "snappy"
  depends_on "lz4"

  # fix the weird library naming scheme in rocksdb Makefile
  patch :DATA

  def install
    ENV.cxx11
    ENV["PORTABLE"] = "1" if build.bottle?
    ENV.append_to_cflags "-DROCKSDB_LITE=1" if build.with? "lite"
    system "make", "clean"
    system "make", "static_lib"
    system "make", "shared_lib"
    system "make", "install", "INSTALL_PATH=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <assert.h>
      #include <rocksdb/options.h>
      #include <rocksdb/memtablerep.h>
      using namespace rocksdb;
      int main() {
        Options options;
        options.memtable_factory.reset(
                    NewHashSkipListRepFactory(16));
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "db_test", "-v", "-std=c++11",
                                "-stdlib=libc++",
                                "-lstdc++",
                                "-lrocksdb",
                                "-lz", "-lbz2",
                                "-lsnappy", "-llz4"
    system "./db_test"
  end
end
__END__
From eb8e3b4c7a5f4d3054f4a79ad7559928e841e57f Mon Sep 17 00:00:00 2001
From: Dave Cottlehuber <dch@skunkwerks.at>
Date: Thu, 23 Jul 2015 15:08:24 +0200
Subject: [PATCH] Fix shared library names on OSX

- OSX format is libname.major.minor.patch.dylib
- closes #666
---
 Makefile | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Makefile b/Makefile
index b09bdd8..4c1003b 100644
--- a/Makefile
+++ b/Makefile
@@ -345,9 +345,16 @@ SHARED_MAJOR = $(ROCKSDB_MAJOR)
 SHARED_MINOR = $(ROCKSDB_MINOR)
 SHARED_PATCH = $(ROCKSDB_PATCH)
 SHARED1 = ${LIBNAME}.$(PLATFORM_SHARED_EXT)
+ifeq ($(PLATFORM), OS_MACOSX)
+SHARED_OSX = $(LIBNAME).$(SHARED_MAJOR)
+SHARED2 = $(SHARED_OSX).$(PLATFORM_SHARED_EXT)
+SHARED3 = $(SHARED_OSX).$(SHARED_MINOR).$(PLATFORM_SHARED_EXT)
+SHARED4 = $(SHARED_OSX).$(SHARED_MINOR).$(SHARED_PATCH).$(PLATFORM_SHARED_EXT)
+else
 SHARED2 = $(SHARED1).$(SHARED_MAJOR)
 SHARED3 = $(SHARED1).$(SHARED_MAJOR).$(SHARED_MINOR)
 SHARED4 = $(SHARED1).$(SHARED_MAJOR).$(SHARED_MINOR).$(SHARED_PATCH)
+endif
 SHARED = $(SHARED1) $(SHARED2) $(SHARED3) $(SHARED4)
 $(SHARED1): $(SHARED4)
 	ln -fs $(SHARED4) $(SHARED1)
