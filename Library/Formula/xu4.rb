require 'formula'

class Xu4 <Formula
  url 'cvs://:pserver:anonymous@xu4.cvs.sourceforge.net:/cvsroot/xu4:u4'
  homepage 'http://xu4.sourceforge.net/'
  version '1.0beta4'
  
  depends_on 'sdl'
  depends_on 'sdl_mixer'
  
  aka 'ultima4'

  def patches
    DATA
  end

  def install
    # Get the SDL prefix so we can copy the ObjC main files.
    sdl_libexec = Formula.factory('sdl').libexec

    ENV.libpng
    
    ultima_zips = [ 
      "http://downloads.sourceforge.net/project/xu4/Ultima%20IV%20for%20DOS/1.01/ultima4-1.01.zip",
      "http://downloads.sourceforge.net/project/xu4/Ultima%204%20VGA%20Upgrade/1.3/u4upgrad.zip"]
    
    ultima_zips.each { |f| curl f, "-O" }
    
    Dir.chdir 'src' do
      `cp -R #{sdl_libexec}/* macosx`
      
      inreplace "Makefile.macosx" do |s|
        s.change_make_var! "WHICH_FRAMEWORK", MACOS_VERSION
        s.remove_make_var! "ARCHES"
        s.change_make_var! "BUNDLE_CONTENTS", "xu4.app/Contents"
        s.gsub! "../../ultima4.zip", "../ultima4-1.01.zip"
        s.gsub! "../../u4upgrad.zip", "../u4upgrad.zip"
      end
      
      system "make -f Makefile.macosx"
      system "make -f Makefile.macosx install"
      
      prefix.install "xu4.app"
    end
  end
  
  def caveats
    "xu4.app installed to #{prefix}"
  end
end


__END__
diff --git a/src/Makefile.macosx b/src/Makefile.macosx
index 4be9444..de85e99 100644
--- a/src/Makefile.macosx
+++ b/src/Makefile.macosx
@@ -2,20 +2,19 @@
 # $Id: Makefile.macosx,v 1.40 2008/04/03 07:14:46 steven-j-s Exp $
 #
 
+WHICH_FRAMEWORK=10.4u
+ARCHES=-arch i386 -arch ppc
+
 BUNDLE_CONTENTS=../../xu4.app/Contents
 
-CC=gcc
-CXX=g++
 UI=sdl
-LIBPNGDIR=../../libpng
 UILIBS=-L$(HOME)/Library/Frameworks \
 	-framework Cocoa \
-	-framework SDL \
-	-framework SDL_mixer
+	-lSDL \
+	-lSDL_mixer
 UIFLAGS=-F/Library/Frameworks \
-	-I/Library/Frameworks/SDL.framework/Headers \
-	-I/Library/Frameworks/SDL_mixer.framework/Headers \
-	-I$(LIBPNGDIR)
+	-I/usr/local/include/SDL \
+	-I/usr/X11/include
 
 FEATURES=-DHAVE_BACKTRACE=0 -DHAVE_VARIADIC_MACROS=1
 
@@ -24,9 +23,9 @@ DEBUGCXXFLAGS=-ggdb
 # Optimising
 #DEBUGCXXFLAGS=-O2 -mdynamic-no-pic
 
-CXXFLAGS=$(FEATURES) -Wall -I. $(UIFLAGS) $(shell xml2-config --cflags) -DVERSION=\"$(VERSION)\" $(DEBUGCXXFLAGS) -DNPERF -DMACOSX -DMACOSX_USER_FILES_PATH=\"/Library/Application\ Support/xu4\" -no-cpp-precomp -L$(LIBPNGDIR) -isysroot /Developer/SDKs/MacOSX10.4u.sdk -arch i386 -arch ppc
+CXXFLAGS=$(FEATURES) -Wall -I. $(UIFLAGS) $(shell xml2-config --cflags) -DVERSION=\"$(VERSION)\" $(DEBUGCXXFLAGS) -DNPERF -DMACOSX -DMACOSX_USER_FILES_PATH=\"/Library/Application\ Support/xu4\" -no-cpp-precomp -L/usr/X11/lib -isysroot /Developer/SDKs/MacOSX$(WHICH_FRAMEWORK).sdk $(ARCHES)
 CFLAGS=$(CXXFLAGS)
-LIBS=$(LIBPNGDIR)/libpng.a $(UILIBS) $(shell xml2-config --libs) -lobjc -lz -arch i386 -arch ppc
+LIBS=-lpng $(UILIBS) $(shell xml2-config --libs) -lobjc -lz $(ARCHES)
 INSTALL=install
 
 OBJS=macosx/SDLMain.o macosx/osxinit.o macosx/osxerror.o
