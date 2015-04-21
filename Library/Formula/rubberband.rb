# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Rubberband < Formula
  homepage "http://breakfastquay.com/rubberband/"
  url "http://code.breakfastquay.com/attachments/download/34/rubberband-1.8.1.tar.bz2"
  version "1.8.1"
  sha256 "ff0c63b0b5ce41f937a8a3bc560f27918c5fe0b90c6bc1cb70829b86ada82b75"

  depends_on "libsndfile"

  patch :p1, :DATA

  # def patches
  #   {:p1 => [
  #       # "https://gist.githubusercontent.com/ryandesign/7896071/raw/cba635cf36e88d24b52b50001af968e6f2c849ba/Makefile.osx.diff"
  #       # "https://gist.githubusercontent.com/pfultz2/f2f40302dcf97bb42984/raw/5ca33b404d284f86c73d59dfaca01dd369bdac58/Makefile.osx.diff"
  #       # "https://gist.githubusercontent.com/pfultz2/257467014d560e8308f0/raw/338786bb12e9755e7a2658ea856f394d4cf97b3f/Makefile.osx.diff"
  #       # "https://gist.githubusercontent.com/pfultz2/257467014d560e8308f0/raw/dae75492127216f2b4789c75199c2e60d963676e/Makefile.osx.diff"
  #       "https://gist.githubusercontent.com/pfultz2/257467014d560e8308f0/raw/81ee995ffb67d1dd32f52fcd0eb9d97f96288c45/Makefile.osx.diff"
  #   ]}
  # end

  def install
    args = %W[
      CC=#{ENV.cc}
      CXX=#{ENV.cxx}
      MACOS_SDK_PATH=#{MacOS.sdk_path}
      PREFIX=#{prefix}
    ]
    system "make", "--file=Makefile.osx", "install", *args
  end
end

__END__
diff --git a/Makefile.osx b/Makefile.osx
index 2318559..95199f9 100644
--- a/Makefile.osx
+++ b/Makefile.osx
@@ -1,35 +1,46 @@
 
+PREFIX		:= /usr/local
+MACOS_SDK_PATH		:=
 CXX		:= g++
 CC		:= gcc
 ARCHFLAGS	:= 
 OPTFLAGS	:= -DNDEBUG -ffast-math -mfpmath=sse -msse -msse2 -O3 -ftree-vectorize
-
-CXXFLAGS	:= $(ARCHFLAGS) $(OPTFLAGS) -I/usr/local/include -DUSE_PTHREADS -DMALLOC_IS_ALIGNED -DHAVE_VDSP -DUSE_SPEEX -DNO_THREAD_CHECKS -DNO_TIMING -Irubberband -I. -Isrc
-
-LIBRARY_LIBS		:= -framework Accelerate
-
+CXXFLAGS	:= $(ARCHFLAGS) $(OPTFLAGS) -F$(MACOS_SDK_PATH)/System/Library/Frameworks -I$(MACOS_SDK_PATH)/usr/include -I/usr/local/include -Irubberband -I. -Isrc -I$(PREFIX)/include -DUSE_PTHREADS -DMALLOC_IS_ALIGNED -DHAVE_VDSP -DUSE_SPEEX -DNO_THREAD_CHECKS -DNO_TIMING
 CFLAGS		:= $(ARCHFLAGS) $(OPTFLAGS)
 LDFLAGS		:= $(ARCHFLAGS) -lpthread $(LDFLAGS)
 
-PROGRAM_LIBS		:= -L/usr/local/lib -lsndfile $(LIBRARY_LIBS)
-VAMP_PLUGIN_LIBS	:= -L/usr/local/lib -lvamp-sdk $(LIBRARY_LIBS)
+LIBRARY_LIBS		:= -framework Accelerate
+PROGRAM_LIBS		:= -L$(PREFIX)/lib -lsndfile $(LIBRARY_LIBS)
+VAMP_PLUGIN_LIBS	:= -L$(PREFIX)/lib -lvamp-sdk $(LIBRARY_LIBS)
 LADSPA_PLUGIN_LIBS	:= $(LIBRARY_LIBS)
 
 MKDIR			:= mkdir
 AR			:= ar
 
-DYNAMIC_LDFLAGS		:= -dynamiclib
+INSTALL_BINDIR		:= $(PREFIX)/bin
+INSTALL_INCDIR		:= $(PREFIX)/include/rubberband
+INSTALL_LIBDIR		:= $(PREFIX)/lib
+INSTALL_VAMPDIR		:= $(PREFIX)/lib/vamp
+INSTALL_LADSPADIR	:= $(PREFIX)/lib/ladspa
+INSTALL_LRDFDIR		:= $(PREFIX)/share/ladspa/rdf
+INSTALL_PKGDIR		:= $(PREFIX)/lib/pkgconfig
+
+LIBNAME			:= librubberband
+
 DYNAMIC_EXTENSION	:= .dylib
+DYNAMIC_FULL_VERSION	:= 2.1.0
+DYNAMIC_ABI_VERSION	:= 2
+DYNAMIC_LDFLAGS		:= -dynamiclib -install_name $(INSTALL_LIBDIR)/$(LIBNAME).$(DYNAMIC_ABI_VERSION)$(DYNAMIC_EXTENSION) -current_version $(DYNAMIC_FULL_VERSION) -compatibility_version $(DYNAMIC_ABI_VERSION)
 
 PROGRAM_TARGET 		:= bin/rubberband
-STATIC_TARGET  		:= lib/librubberband.a
-DYNAMIC_TARGET 		:= lib/librubberband$(DYNAMIC_EXTENSION)
+STATIC_TARGET  		:= lib/$(LIBNAME).a
+DYNAMIC_TARGET 		:= lib/$(LIBNAME)$(DYNAMIC_EXTENSION)
 VAMP_TARGET    		:= lib/vamp-rubberband$(DYNAMIC_EXTENSION)
 LADSPA_TARGET  		:= lib/ladspa-rubberband$(DYNAMIC_EXTENSION)
 
-default:	bin lib $(STATIC_TARGET) $(DYNAMIC_TARGET) $(PROGRAM_TARGET)
+default:	bin lib $(PROGRAM_TARGET) $(STATIC_TARGET) $(DYNAMIC_TARGET)
 
-all:	bin lib $(STATIC_TARGET) $(DYNAMIC_TARGET) $(PROGRAM_TARGET) $(VAMP_TARGET) $(LADSPA_TARGET)
+all:	bin lib $(PROGRAM_TARGET) $(STATIC_TARGET) $(DYNAMIC_TARGET) $(VAMP_TARGET) $(LADSPA_TARGET)
 
 static:		$(STATIC_TARGET)
 dynamic:	$(DYNAMIC_TARGET)
@@ -121,10 +132,10 @@ VAMP_OBJECTS    := $(VAMP_SOURCES:.cpp=.o)
 LADSPA_OBJECTS  := $(LADSPA_SOURCES:.cpp=.o)
 
 $(PROGRAM_TARGET):	$(LIBRARY_OBJECTS) $(PROGRAM_OBJECTS)
-	$(CXX) -o $@ $^ $(PROGRAM_LIBS) $(PROGRAM_LIBS) $(LDFLAGS)
+	$(CXX) -o $@ $^ $(PROGRAM_LIBS) $(LDFLAGS)
 
 $(STATIC_TARGET):	$(LIBRARY_OBJECTS)
-	$(AR) rc $@ $^
+	$(AR) rsc $@ $^
 
 $(DYNAMIC_TARGET):	$(LIBRARY_OBJECTS)
 	$(CXX) $(DYNAMIC_LDFLAGS) $^ -o $@ $(LIBRARY_LIBS) $(LDFLAGS)
@@ -140,6 +151,30 @@ bin:
 lib:
 	$(MKDIR) $@
 
+install:	default
+	$(MKDIR) -p $(DESTDIR)$(INSTALL_BINDIR)
+	$(MKDIR) -p $(DESTDIR)$(INSTALL_INCDIR)
+	$(MKDIR) -p $(DESTDIR)$(INSTALL_LIBDIR)
+	$(MKDIR) -p $(DESTDIR)$(INSTALL_VAMPDIR)
+	$(MKDIR) -p $(DESTDIR)$(INSTALL_LADSPADIR)
+	$(MKDIR) -p $(DESTDIR)$(INSTALL_LRDFDIR)
+	$(MKDIR) -p $(DESTDIR)$(INSTALL_PKGDIR)
+	cp $(PROGRAM_TARGET) $(DESTDIR)$(INSTALL_BINDIR)
+	cp $(PUBLIC_INCLUDES) $(DESTDIR)$(INSTALL_INCDIR)
+	cp $(STATIC_TARGET) $(DESTDIR)$(INSTALL_LIBDIR)
+	rm -f $(DESTDIR)$(INSTALL_LIBDIR)/$(LIBNAME).$(DYNAMIC_ABI_VERSION)$(DYNAMIC_EXTENSION)
+	rm -f $(DESTDIR)$(INSTALL_LIBDIR)/$(LIBNAME)$(DYNAMIC_EXTENSION)
+	cp $(DYNAMIC_TARGET) $(DESTDIR)$(INSTALL_LIBDIR)/$(LIBNAME).$(DYNAMIC_FULL_VERSION)$(DYNAMIC_EXTENSION)
+	ln -s $(LIBNAME).$(DYNAMIC_FULL_VERSION)$(DYNAMIC_EXTENSION) $(DESTDIR)$(INSTALL_LIBDIR)/$(LIBNAME).$(DYNAMIC_ABI_VERSION)$(DYNAMIC_EXTENSION)
+	ln -s $(LIBNAME).$(DYNAMIC_FULL_VERSION)$(DYNAMIC_EXTENSION) $(DESTDIR)$(INSTALL_LIBDIR)/$(LIBNAME)$(DYNAMIC_EXTENSION)
+#	cp $(VAMP_TARGET) $(DESTDIR)$(INSTALL_VAMPDIR)
+#	cp vamp/vamp-rubberband.cat $(DESTDIR)$(INSTALL_VAMPDIR)
+#	cp $(LADSPA_TARGET) $(DESTDIR)$(INSTALL_LADSPADIR)
+#	cp ladspa/ladspa-rubberband.cat $(DESTDIR)$(INSTALL_LADSPADIR)
+#	cp ladspa/ladspa-rubberband.rdf $(DESTDIR)$(INSTALL_LRDFDIR)
+	sed "s,%PREFIX%,$(PREFIX)," rubberband.pc.in \
+	  > $(DESTDIR)$(INSTALL_PKGDIR)/rubberband.pc
+
 clean:
 	rm -f $(LIBRARY_OBJECTS) $(PROGRAM_OBJECTS) $(LADSPA_OBJECTS) $(VAMP_OBJECTS)
 
