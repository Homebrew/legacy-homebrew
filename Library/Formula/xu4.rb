require 'formula'

class Xu4 <Formula
  url 'http://xu4.svn.sourceforge.net/svnroot/xu4/trunk/u4',
          :revision => '2725'
  homepage 'http://xu4.sourceforge.net/'
  version '1.0beta4-pre'

  head 'http://xu4.svn.sourceforge.net/svnroot/xu4/trunk/u4'

  depends_on 'sdl'
  depends_on 'sdl_mixer'

  def patches
    DATA
  end

  def install
    ENV.libpng

    ultima_zips = [
      "Ultima%20IV%20for%20DOS/1.01/ultima4-1.01.zip",
      "Ultima%204%20VGA%20Upgrade/1.3/u4upgrad.zip"]

    ohai "Downloading support files"
    ultima_zips.each { |f| curl "http://downloads.sourceforge.net/project/xu4/#{f}", "-O" }

    Dir.chdir 'src' do
      # Copy over SDL's ObjC main files
      `cp -R #{Formula.factory('sdl').libexec}/* macosx`

      inreplace "Makefile.macosx" do |s|
        s.remove_make_var! "WHICH_ARCH"
        s.change_make_var! "WHICH_FRAMEWORK", "MacOSX#{MACOS_VERSION}.sdk"
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
index 9745ff4..88cb193 100644
--- a/src/Makefile.macosx
+++ b/src/Makefile.macosx
@@ -2,6 +2,9 @@
 # $Id: Makefile.macosx 2717 2008-04-03 07:14:46Z steven-j-s $
 #
 
+WHICH_ARCH=-arch i386 -arch ppc
+WHICH_FRAMEWORK=MacOSX10.4u.sdk
+
 BUNDLE_CONTENTS=../../xu4.app/Contents
 
 CC=gcc
@@ -10,12 +13,11 @@ UI=sdl
 LIBPNGDIR=../../libpng
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
 
@@ -24,9 +26,9 @@ DEBUGCXXFLAGS=-ggdb
 # Optimising
 #DEBUGCXXFLAGS=-O2 -mdynamic-no-pic
 
-CXXFLAGS=$(FEATURES) -Wall -I. $(UIFLAGS) $(shell xml2-config --cflags) -DVERSION=\"$(VERSION)\" $(DEBUGCXXFLAGS) -DNPERF -DMACOSX -DMACOSX_USER_FILES_PATH=\"/Library/Application\ Support/xu4\" -no-cpp-precomp -L$(LIBPNGDIR) -isysroot /Developer/SDKs/MacOSX10.4u.sdk -arch i386 -arch ppc
+CXXFLAGS=$(FEATURES) -Wall -I. $(UIFLAGS) $(shell xml2-config --cflags) -DVERSION=\"$(VERSION)\" $(DEBUGCXXFLAGS) -DNPERF -DMACOSX -DMACOSX_USER_FILES_PATH=\"/Library/Application\ Support/xu4\" -no-cpp-precomp -L$(LIBPNGDIR) -isysroot /Developer/SDKs/$(WHICH_FRAMEWORK) $(WHICH_ARCH)
 CFLAGS=$(CXXFLAGS)
-LIBS=$(LIBPNGDIR)/libpng.a $(UILIBS) $(shell xml2-config --libs) -lobjc -lz -arch i386 -arch ppc
+LIBS=-lpng $(UILIBS) $(shell xml2-config --libs) -lobjc -lz $(WHICH_ARCH)
 INSTALL=install
 
 OBJS=macosx/SDLMain.o macosx/osxinit.o macosx/osxerror.o
