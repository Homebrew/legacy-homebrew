require 'formula'

class Ice < Formula
  homepage 'http://www.zeroc.com'
  url 'http://www.zeroc.com/download/Ice/3.5/Ice-3.5.0.tar.gz'
  sha1 '699376c76cfda9ffb24c903a1ea18b789f582421'

  option 'doc', 'Install documentation'
  option 'demo', 'Build demos'

  depends_on 'berkeley-db'
  depends_on 'mcpp'

  def patches
    DATA
  end

  def install
    ENV.O2
    inreplace "cpp/config/Make.rules" do |s|
      s.gsub! "#OPTIMIZE", "OPTIMIZE"
      s.gsub! "/opt/Ice-$(VERSION)", prefix
      s.gsub! "/opt/Ice-$(VERSION_MAJOR).$(VERSION_MINOR)", prefix
    end

    # what want we build?
    wb = 'config src include'
    wb += ' doc' if build.include? 'doc'
    wb += ' demo' if build.include? 'demo'
    inreplace "cpp/Makefile" do |s|
      s.change_make_var! "SUBDIRS", wb
    end

    inreplace "cpp/config/Make.rules.Darwin" do |s|
      s.change_make_var! "CXXFLAGS", "#{ENV.cflags} -Wall -D_REENTRANT"
    end

    cd "cpp" do
      system "make"
      system "make install"
    end
  end
end

__END__
diff -urN Ice-3.5.0.original/cpp/config/Make.rules.Darwin Ice-3.5.0/cpp/config/Make.rules.Darwin
--- ./cpp/config/Make.rules.Darwin	2013-03-11 15:19:46.000000000 +0000
+++ ./cpp/config/Make.rules.Darwin	2013-04-02 18:03:40.000000000 +0100
@@ -11,25 +11,18 @@
 # This file is included by Make.rules when uname is Darwin.
 #
 
-CXX			= xcrun clang++
+CXX			?= g++
 
 CXXFLAGS		= -Wall -Werror -D_REENTRANT
 
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
@@ -72,7 +65,7 @@
 ICEUTIL_OS_LIBS         = -lpthread
 ICE_OS_LIBS             = -ldl
 
-PLATFORM_HAS_READLINE   := no
+PLATFORM_HAS_READLINE   := yes
 
 #
 # QT is used only for the deprecated IceGrid and IceStorm SQL plugins
