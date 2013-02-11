require 'formula'

class Poco < Formula
  homepage 'http://pocoproject.org/'
  url 'http://pocoproject.org/releases/poco-1.4.6/poco-1.4.6.tar.gz'
  sha1 'e96260f5a5309e129bdea4251c8e26e14bd0c9bc'

  option 'with-c++11', 'Compile using std=c++11 and stdlib=libc++' if MacOS.version >= :lion

  def install
    arch = Hardware.is_64_bit? ? 'Darwin64': 'Darwin32'
    arch << '-clang' if ENV.compiler == :clang

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--config=#{arch}",
                          "--omit=Data/MySQL,Data/ODBC",
                          "--no-samples",
                          "--no-tests"
    system "make install CC=#{ENV.cc} CXX=#{ENV.cxx}"
  end

  def patches
    # POCO 1.4.6 doesn't support passing C++ compiler specific flags to configure script
    # and the build fails with c++11/libc++ are enabled so a bit of patching is needed
    DATA if build.include? 'with-c++11'
  end
end

__END__
diff --git a/Foundation/src/DirectoryWatcher.cpp b/Foundation/src/DirectoryWatcher.cpp
index 8dea119..9d6a7eb 100644
--- a/Foundation/src/DirectoryWatcher.cpp
+++ b/Foundation/src/DirectoryWatcher.cpp
@@ -53,6 +53,7 @@
 #include <sys/types.h>
 #include <sys/event.h>
 #include <sys/time.h>
+#include <unistd.h>
 #endif
 #include <algorithm>
 #include <map>

diff --git a/build/rules/global b/build/rules/global
index dc954cc..9455bed 100644
--- a/build/rules/global
+++ b/build/rules/global
@@ -214,9 +214,11 @@ endif
 #
 COMMONFLAGS = -DPOCO_BUILD_HOST=$(HOSTNAME) $(POCO_FLAGS)
 CFLAGS     += $(COMMONFLAGS) $(SYSFLAGS)
-CXXFLAGS   += $(COMMONFLAGS) $(SYSFLAGS)
+CXXFLAGS   += $(COMMONFLAGS) $(SYSFLAGS) -std=c++11 -stdlib=libc++
 LINKFLAGS  += $(COMMONFLAGS) $(SYSFLAGS)
 
+SHLIBFLAGS += -stdlib=libc++
+
 ifeq ($(OSARCH_64BITS),1)
 CFLAGS     += $(CFLAGS64)
 CXXFLAGS   += $(CXXFLAGS64)
