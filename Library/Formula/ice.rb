require 'formula'

class Ice < Formula
  homepage 'http://www.zeroc.com'
  url 'http://www.zeroc.com/download/Ice/3.5/Ice-3.5.1.tar.gz'
  sha1 '63599ea22a1e9638a49356682c9e516b7c2c454f'

  option 'doc', 'Install documentation'
  option 'demo', 'Build demos'

  depends_on 'berkeley-db'
  depends_on 'mcpp'

  def patches
    DATA
  end

  def install
    ENV.O2

    # what do we want to build?
    wb = 'config src include'
    wb += ' doc' if build.include? 'doc'
    wb += ' demo' if build.include? 'demo'
    inreplace "cpp/Makefile" do |s|
      s.change_make_var! "SUBDIRS", wb
    end

    args = %W[
      prefix=#{prefix}
      embedded_runpath_prefix=#{prefix}
      OPTIMIZE=yes
    ]
    args << "CXXFLAGS=#{ENV.cflags} -Wall -D_REENTRANT"

    cd "cpp" do
      system "make", *args
      system "make", "install", *args
    end
  end
end

__END__
diff -urN Ice-3.5.1.original/cpp/config/Make.rules.Darwin Ice-3.5.1/cpp/config/Make.rules.Darwin
--- Ice-3.5.1.original/cpp/config/Make.rules.Darwin	2013-10-04 16:48:14.000000000 +0100
+++ Ice-3.5.1/cpp/config/Make.rules.Darwin	2013-10-09 10:09:32.000000000 +0100
@@ -11,26 +11,19 @@
 # This file is included by Make.rules when uname is Darwin.
 #
 
-CXX			= xcrun clang++
+CXX			?= g++
 
 CPPFLAGS 	        += -pthread
 CXXFLAGS		+= -Wall -Werror
 
 ifeq ($(OPTIMIZE),yes)
-     #
-     # By default we build binaries with both architectures when optimization is enabled.
-     #
-     ifeq ($(CXXARCHFLAGS),)
-     	CXXARCHFLAGS	:= -arch i386 -arch x86_64
-     endif   
-     CXXFLAGS		:= $(CXXARCHFLAGS) -O2 -DNDEBUG $(CXXFLAGS)
+     CXXFLAGS		:= -O2 -DNDEBUG $(CXXFLAGS)
 else
-     CXXFLAGS		:= $(CXXARCHFLAGS) -g $(CXXFLAGS)
+     CXXFLAGS		:= -g $(CXXFLAGS)
 endif
 
 ifeq ($(CPP11), yes)
     CPPFLAGS += --std=c++11
-    CXXFLAGS += --stdlib=libc++
 endif
 
 #
