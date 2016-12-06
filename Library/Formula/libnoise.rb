require 'formula'

def universal?
  ARGV.flag? '--universal'
end
  

class Libnoise <Formula
  url 'http://freefr.dl.sourceforge.net/project/libnoise/libnoise%20sources/1.0.0/libnoisesrc-1.0.0.zip'
  homepage 'http://libnoise.sourceforge.net'
  md5 'fc0d9b4f6477397568c3a9d5294b3b8c'

  def patches
    DATA
  end

  def install
    ENV.universal_binary if universal?
    Dir.chdir "noise" do
      system "make", "src"
      system "make", "lib"
      
      Dir.chdir "lib" do
        lib.install Dir['*']
      end
      
      Dir.chdir "include" do
        noiseincludes = include / 'noise'
        noiseincludes.mkpath
        noiseincludes.install(Dir['*'].reject { |ea| ea == 'Makefile' })        
      end
    end
  end
end
__END__
diff -Naur libnoisesrc-1.0.0.orig/noise/lib/Makefile libnoisesrc-1.0.0/noise/lib/Makefile
--- libnoisesrc-1.0.0.orig/noise/lib/Makefile	2004-10-24 21:21:12.000000000 +0200
+++ libnoisesrc-1.0.0/noise/lib/Makefile	2010-12-14 09:49:20.000000000 +0100
@@ -1,8 +1,10 @@
 VPATH=../src/
 
 .PHONY: all clean
-all: libnoise.a libnoise.la libnoise.so.0.3
+all: libnoise.a libnoise.0.3.dylib
 	-cp $? .
+	-ln -s libnoise.0.3.dylib libnoise.0.dylib 
+	-ln -s libnoise.0.3.dylib libnoise.dylib 
 
 clean:
 	-rm libnoise.*
diff -Naur libnoisesrc-1.0.0.orig/noise/src/Makefile libnoisesrc-1.0.0/noise/src/Makefile
--- libnoisesrc-1.0.0.orig/noise/src/Makefile	2004-10-24 21:21:12.000000000 +0200
+++ libnoisesrc-1.0.0/noise/src/Makefile	2010-12-14 09:19:50.000000000 +0100
@@ -1,5 +1,3 @@
-LIBTOOL=libtool
-
 # defines source files and vpaths
 include Sources
 
@@ -8,21 +6,19 @@
 # What source objects are we building?
 OBJECTS=$(SOURCES:.cpp=.o)
 
-.PHONY: all clean cleandeps cleanobjs cleanlib libnoise libnoise.so libnoise.so.0
+.PHONY: all clean cleandeps cleanobjs cleanlib libnoise libnoise.dylib libnoise.0.dylib
 
 # hooks for future makefiles being able to make multiple SOs, or older SOs
-libnoise: libnoise.so libnoise.a libnoise.la
-libnoise.so: libnoise.so.0
-libnoise.so.0: libnoise.so.0.3
+libnoise: libnoise.dylib libnoise.a
+libnoise.dylib: libnoise.0.dylib
+libnoise.0.dylib: libnoise.0.3.dylib
 
 # Real build targets
-libnoise.so.0.3: $(OBJECTS)
-	$(LIBTOOL) --mode=link $(CXX) $(LDFLAGS) -shared -Wl,-soname=libnoise.so.0 -o $@ $(OBJECTS:.o=.lo)
+libnoise.0.3.dylib: $(OBJECTS)
+	$(CXX) -dynamiclib -o $@ $(CXXFLAGS) $(OBJECTS)
 
 libnoise.a: $(OBJECTS)
-	$(LIBTOOL) --mode=link $(CXX) $(LDFLAGS) -o $@ $(OBJECTS)
-libnoise.la: $(OBJECTS)
-	$(LIBTOOL) --mode=link $(CXX) $(LDFLAGS) -o $@ $(OBJECTS:.o=.lo)
+	libtool -static -o $@ $(OBJECTS)
 
 clean:	cleandeps cleanobjs cleanlib
 cleandeps:
@@ -32,9 +28,8 @@
 	-rm $(OBJECTS:.o=.lo) #clean up after libtool
 	-rm -rf .libs model/.libs module/.libs
 cleanlib:
-	-rm libnoise.so.0.3
+	-rm libnoise.0.3.dylib
 	-rm libnoise.a
-	-rm libnoise.la
 
 # Utility rules
 # Generates dependancy files:
@@ -44,13 +39,6 @@
          sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
          rm -f $@.$$$$
 
-# C and C++ libtool (rather than raw CXX/CC) use
-%.o %.lo: %.cpp
-	$(LIBTOOL) --mode=compile $(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $(@:.lo=.o)
-
-%.o %.lo: %.c
-	$(LIBTOOL) --mode=compile $(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $(@:.lo=.o)
-
 # If dependancies have never been built this will produce a horde of
 # "file not found" warnings and *then* build the deps.  Very odd.
 include $(DEPENDS)
