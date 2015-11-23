class OpenZwave < Formula
  desc "Library for selected Z-Wave PC controllers"
  homepage "http://www.openzwave.com"
  url "http://old.openzwave.com/downloads/openzwave-1.2.919.tar.gz"
  sha256 "473229f3dd3d6b260e6584b17e5c5f2e09e61805f89763f486a9f7aa2b4181ba"

  bottle do
    sha256 "9ceb267d8fb564daefb535f65ac71f426535f7552b9feffcb3638793f0c40810" => :yosemite
    sha256 "753eb6cb76dd0c170c1e84285a702fb9fb49c76aa8d59970ecea2160938f0bba" => :mavericks
    sha256 "be2b4c51703ee93865a6c755a4394b6271eb599ea98a7431b54d090276a0e9f7" => :mountain_lion
  end

  # Patch to build a .dylib instead of a .so
  # This patch has been merged upstream and can be removed after the next release:
  # https://code.google.com/p/open-zwave/source/detail?r=954
  patch :DATA

  def install
    ENV["BUILD"] = "release"
    ENV["PREFIX"] = prefix

    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include "Options.h"
      int main() {
        OpenZWave::Options::Create("", "", "");
        return 0;
      }
    EOS
    system ENV.cxx, "-o", "test", "-I", prefix/"include/openzwave", "-lopenzwave", "test.cpp"
    system "./test"
  end
end

__END__
diff --git a/cpp/build/Makefile b/cpp/build/Makefile
index 24df4f5..b064029 100644
--- a/cpp/build/Makefile
+++ b/cpp/build/Makefile
@@ -23,16 +23,24 @@ top_srcdir := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))../../)
 
 include $(top_srcdir)/cpp/build/support.mk
 
+#Mac prefers a dylib, not a so
+ifeq ($(UNAME),Darwin)
+SHARED_LIB_NAME=libopenzwave-$(VERSION).dylib
+SHARED_LIB_UNVERSIONED=libopenzwave.dylib
+else
+SHARED_LIB_NAME=libopenzwave.so.$(VERSION)
+SHARED_LIB_UNVERSIONED=libopenzwave.so
+endif
 
 #if we are on a Mac, add these flags and libs to the compile and link phases 
 ifeq ($(UNAME),Darwin)
 CFLAGS	+= -c -DDARWIN -arch i386 -arch x86_64
-LDFLAGS += -arch i386 -arch x86_64
+LDFLAGS += -arch i386 -arch x86_64 -dynamiclib
 LIBS	+= -framework IOKit -framework CoreFoundation -arch i386 -arch x86_64
 else ifeq ($(UNAME),FreeBSD)
 CFLAGS += -I/usr/local/include
 else
-LDFLAGS += -Wl,-soname,libopenzwave.so.$(VERSION)
+LDFLAGS += -shared -Wl,-soname,$(SHARED_LIB_NAME)
 LIBS 	+= -ludev
 endif
 
@@ -74,10 +82,10 @@ indep := $(notdir $(filter-out $(top_srcdir)/cpp/src/vers.cpp, $(wildcard $(top_
 aes := $(notdir $(wildcard $(top_srcdir)/cpp/src/aes/*.c))
 
 
-default: $(LIBDIR)/libopenzwave.a $(LIBDIR)/libopenzwave.so.$(VERSION)
+default: $(LIBDIR)/libopenzwave.a $(LIBDIR)/$(SHARED_LIB_NAME)
 
 clean:
-	@rm -rf $(DEPDIR) $(OBJDIR) $(LIBDIR)/libopenzwave.so* $(LIBDIR)/libopenzwave.a $(top_builddir)/libopenzwave.pc $(top_builddir)/docs/api $(top_builddir)/Doxyfile
+	@rm -rf $(DEPDIR) $(OBJDIR) $(LIBDIR)/libopenzwave.so* $(LIBDIR)/libopenzwave-*.dylib $(LIBDIR)/libopenzwave.a $(top_builddir)/libopenzwave.pc $(top_builddir)/docs/api $(top_builddir)/Doxyfile
 
 
 -include $(patsubst %.cpp,$(DEPDIR)/%.d,$(tinyxml))
@@ -110,7 +118,7 @@ $(LIBDIR)/libopenzwave.a:	$(patsubst %.cpp,$(OBJDIR)/%.o,$(tinyxml)) \
 	@$(AR) $@ $+
 	@$(RANLIB) $@
 
-$(LIBDIR)/libopenzwave.so.$(VERSION):	$(patsubst %.cpp,$(OBJDIR)/%.o,$(tinyxml)) \
+$(LIBDIR)/$(SHARED_LIB_NAME):	$(patsubst %.cpp,$(OBJDIR)/%.o,$(tinyxml)) \
 			$(patsubst %.c,$(OBJDIR)/%.o,$(hidapi)) \
 			$(patsubst %.c,$(OBJDIR)/%.o,$(aes)) \
 			$(patsubst %.cpp,$(OBJDIR)/%.o,$(cclasses)) \
@@ -120,7 +128,7 @@ $(LIBDIR)/libopenzwave.so.$(VERSION):	$(patsubst %.cpp,$(OBJDIR)/%.o,$(tinyxml))
 			$(OBJDIR)/vers.o
 	@echo "Linking Shared Library"
-	@$(LD) $(LDFLAGS) -shared  -o $@ $+ $(LIBS)
-	@ln -sf libopenzwave.so.$(VERSION) $(LIBDIR)/libopenzwave.so
+	@$(LD) $(LDFLAGS) -o $@ $+ $(LIBS)
+	@ln -sf $(SHARED_LIB_NAME) $(LIBDIR)/$(SHARED_LIB_UNVERSIONED)
 
 ifeq ($(PKGCONFIG),)
 $(top_builddir)/libopenzwave.pc: $(top_srcdir)/cpp/build/libopenzwave.pc.in
@@ -155,10 +163,10 @@ doc: $(top_builddir)/Doxyfile
 	@cd $(top_builddir); $(DOXYGEN)
 endif
 
-install: $(LIBDIR)/libopenzwave.so.$(VERSION) doc $(top_builddir)/libopenzwave.pc 
+install: $(LIBDIR)/$(SHARED_LIB_NAME) doc $(top_builddir)/libopenzwave.pc 
 	install -d $(DESTDIR)/$(instlibdir)/
-	cp  $(LIBDIR)/libopenzwave.so.$(VERSION) $(DESTDIR)/$(instlibdir)/libopenzwave.so.$(VERSION)
-	ln -sf libopenzwave.so.$(VERSION) $(DESTDIR)/$(instlibdir)/libopenzwave.so
+	cp  $(LIBDIR)/$(SHARED_LIB_NAME) $(DESTDIR)/$(instlibdir)/$(SHARED_LIB_NAME)
+	ln -sf $(SHARED_LIB_NAME) $(DESTDIR)/$(instlibdir)/$(SHARED_LIB_UNVERSIONED)
 	install -d $(DESTDIR)/$(includedir)
 	install -m 0644 $(top_srcdir)/cpp/src/*.h $(DESTDIR)/$(includedir)
 	install -d $(DESTDIR)/$(includedir)/command_classes/
diff --git a/cpp/examples/MinOZW/Makefile b/cpp/examples/MinOZW/Makefile
index 0f1fd50..3805a39 100644
--- a/cpp/examples/MinOZW/Makefile
+++ b/cpp/examples/MinOZW/Makefile
@@ -19,7 +19,7 @@ top_srcdir := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))../../../)
 
 
 INCLUDES	:= -I $(top_srcdir)/cpp/src -I $(top_srcdir)/cpp/tinyxml/ -I $(top_srcdir)/cpp/hidapi/hidapi/
-LIBS =  $(wildcard $(LIBDIR)/*.so $(top_builddir)/*.so $(top_builddir)/cpp/build/*.so )
+LIBS =  $(wildcard $(LIBDIR)/*.so $(LIBDIR)/*.dylib $(top_builddir)/*.so $(top_builddir)/*.dylib $(top_builddir)/cpp/build/*.so $(top_builddir)/cpp/build/*.dylib )
 LIBSDIR = $(abspath $(dir $(firstword $(LIBS))))
 minozwsrc := $(notdir $(wildcard $(top_srcdir)/cpp/examples/MinOZW/*.cpp))
 VPATH := $(top_srcdir)/cpp/examples/MinOZW
