require 'formula'

class Xu4 < Formula
  url 'http://xu4.svn.sourceforge.net/svnroot/xu4/trunk/u4',
          :revision => '2999'
  homepage 'http://xu4.sourceforge.net/'
  version 'r2999'

  head 'http://xu4.svn.sourceforge.net/svnroot/xu4/trunk/u4'

  depends_on 'sdl'
  depends_on 'sdl_mixer'

  def patches
    DATA
  end

  def install
    ENV.x11

    ultima_zips = [
      "http://www.thatfleminggent.com/ultima/ultima4.zip",
      "http://downloads.sourceforge.net/project/xu4/Ultima%204%20VGA%20Upgrade/1.3/u4upgrad.zip"
    ]

    ohai "Downloading support files"
    ultima_zips.each { |f| curl f, "-O" }

    Dir.chdir 'src' do
      # Copy over SDL's ObjC main files
      `cp -R #{Formula.factory('sdl').libexec}/* macosx`

      inreplace "Makefile.macosx" do |s|
        s.change_make_var! "SYSROOT", "/Developer/SDKs/MacOSX#{MACOS_VERSION}.sdk"
        s.remove_make_var! "WHICH_ARCH"
        s.change_make_var! "PREFIX", HOMEBREW_PREFIX
        s.change_make_var! "BUNDLE_CONTENTS", "xu4.app/Contents"
        s.change_make_var! "CC", ENV.cc
        s.change_make_var! "CXX", ENV.cxx
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
index c8e4812..1317029 100644
--- a/src/Makefile.macosx
+++ b/src/Makefile.macosx
@@ -18,15 +18,16 @@ UI=sdl
 PREFIX=/usr
 UILIBS=-L/Library/Frameworks \
 	-framework Cocoa \
-	-framework SDL \
-	-framework SDL_mixer \
-	-framework libpng
+	-lpng \
+	-lSDL \
+	-lSDL_mixer
 	
 UIFLAGS=-F/Library/Frameworks \
-	-I/Library/Frameworks/SDL.framework/Headers \
-	-I/Library/Frameworks/SDL_mixer.framework/Headers \
 	-I/Library/Frameworks/libpng.framework/Headers \
-	-I$(PREFIX)/include
+	-I$(PREFIX)/include \
+	-I$(PREFIX)/include/SDL \
+	-I/usr/include \
+	-I/usr/X11/include
 
 FEATURES=-DHAVE_BACKTRACE=0 -DHAVE_VARIADIC_MACROS=1

diff --git a/src/Makefile.macosx b/src/Makefile.macosx
index c7b9a32..f721589 100644
--- a/src/Makefile.macosx
+++ b/src/Makefile.macosx
@@ -3,8 +3,8 @@
 #
 
 # name and path to ultima4.zip and u4upgrad.zip
-ULTIMA4=ultima4*.zip
-U4UPGRADE=u4upgrad.zip
+ULTIMA4=../ultima4.zip
+U4UPGRADE=../u4upgrad.zip
 
 # for crosscompiling arch ppc or i386 from OS X 10.6 use 
 # CC=/usr/bin/gcc-4.0
@@ -100,7 +100,7 @@ bundle: u4
 	cp ../graphics/vga2/*.png $(bundle_name)/Contents/Resources/vga2
 	# if you want to include the ultima4.zip in the bundle uncomment the
 	# following line.
-	# cp $(ULTIMA4) $(bundle_name)/Contents/Resources
+	cp $(ULTIMA4) $(bundle_name)/Contents/Resources
 	cp $(U4UPGRADE) $(bundle_name)/Contents/Resources
 	cp $< $(bundle_name)/Contents/MacOS
