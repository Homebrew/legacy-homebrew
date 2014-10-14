require 'formula'

class Ice < Formula
  homepage 'http://www.zeroc.com'
  url 'http://www.zeroc.com/download/Ice/3.5/Ice-3.5.1.tar.gz'
  sha1 '63599ea22a1e9638a49356682c9e516b7c2c454f'

  option 'doc', 'Install documentation'
  option 'demo', 'Build demos'

  depends_on 'berkeley-db'
  depends_on 'mcpp'
  depends_on :python => :optional

  # 1. TODO: document the first patch
  # 2. Patch to fix build with libc++, reported upstream:
  # http://www.zeroc.com/forums/bug-reports/6152-mavericks-build-failure-because-unexported-symbols.html
  patch :DATA

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
      install_mandir=#{man1}
      install_slicedir=#{share}/Ice-3.5/slice
      embedded_runpath_prefix=#{prefix}
      OPTIMIZE=yes
    ]
    args << "CXXFLAGS=#{ENV.cflags} -Wall -D_REENTRANT"

    # Unset ICE_HOME as it interferes with the build
    ENV.delete('ICE_HOME')

    cd "cpp" do
      system "make", *args
      system "make", "install", *args
    end

    cd "php" do
      system "make", *args
      system "make", "install", *args
    end

    if build.with? "python"
      args << "install_pythondir=#{lib}/python2.7/site-packages"
      args << "install_libdir=#{lib}/python2.7/site-packages"
      cd "py" do
        system "make", *args
        system "make", "install", *args
      end
    end

    libexec.install "#{lib}/ImportKey.class"
  end

  test do
    system "#{bin}/icebox", "--version"
  end

  def caveats
    <<-EOS.undent
      To enable IcePHP, you will need to change your php.ini
      to load the IcePHP extension. You can do this by adding
      IcePHP.dy to your list of extensions:

          extension=#{prefix}/php/IcePHP.dy

      Typical Ice PHP scripts will also expect to be able to 'require Ice.php'.

      You can ensure this is possible by appending the path to
      Ice's PHP includes to your global include_path in php.ini:

          include_path=<your-original-include-path>:#{prefix}/php

      However, you can also accomplish this on a script-by-script basis
      or via .htaccess if you so desire...
      EOS
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
diff -urN Ice-3.5.1.original/py/config/Make.rules.Darwin Ice-3.5.1/py/config/Make.rules.Darwin
--- Ice-3.5.1.original/py/config/Make.rules.Darwin	2013-10-04 16:48:15.000000000 +0100
+++ Ice-3.5.1/py/config/Make.rules.Darwin	2013-10-10 12:09:45.000000000 +0100
@@ -17,19 +17,3 @@
 mksoname		= $(if $(2),lib$(1).$(2).so,lib$(1).so)
 mklibname       = lib$(1).so
 
-#
-# We require Python to be built as a Framework for the IcePy plug-in.
-#
-ifneq ($(PYTHON_HOME),)
-    ifeq ($(shell test ! -f $(PYTHON_HOME)/Python && echo 0),0)
-        $(error Unable to find Python framework See config/Make.rules.Darwin)
-    endif
-    PYTHON_LIBS		= -F$(patsubst %/Python.framework/Versions/,%,$(dir $(PYTHON_HOME))) -framework Python
-else
-    XCODE_PATH  = $(shell xcode-select --print-path)
-    SDKS_DIR    = $(XCODE_PATH)/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk
-    PYTHON_HOME	= $(SDKS_DIR)/System/Library/Frameworks/Python.framework/Versions/Current
-    PYTHON_LIBS	= -framework Python
-endif
-
-PYTHON_INCLUDE_DIR	= $(PYTHON_HOME)/include/$(PYTHON_VERSION)
diff -urN Ice-3.5.1.original/cpp/src/IceGrid/DescriptorHelper.h Ice-3.5.1/cpp/src/IceGrid/DescriptorHelper.h
--- Ice-3.5.1.original/cpp/src/IceGrid/DescriptorHelper.h	2013-10-04 16:48:14.000000000 +0100
+++ Ice-3.5.1/cpp/src/IceGrid/DescriptorHelper.h	2013-11-15 00:11:22.000000000 +0000
@@ -247,7 +247,6 @@
     ServerInstanceHelper(const ServerInstanceDescriptor&, const Resolver&, bool);
     ServerInstanceHelper(const ServerDescriptorPtr&, const Resolver&, bool);
     
-    void operator=(const ServerInstanceHelper&);
     bool operator==(const ServerInstanceHelper&) const;
     bool operator!=(const ServerInstanceHelper&) const;
 
@@ -265,7 +264,7 @@
 
     void init(const ServerDescriptorPtr&, const Resolver&, bool);
 
-    const ServerInstanceDescriptor _def;
+    ServerInstanceDescriptor _def;
     std::string _id;
     ServerInstanceDescriptor _instance;
 
