require 'brewkit'

class Atomicparsley <Formula
  @url='http://downloads.sourceforge.net/project/atomicparsley/atomicparsley/AtomicParsley%20v0.9.0/AtomicParsley-source-0.9.0.zip'
  @homepage='http://atomicparsley.sourceforge.net/'
  @md5='681e6ecec2921c98e07a9262bdcd6cf2'

  def patches
    DATA
  end

  def install
    Dir.chdir("AtomicParsley-source-0.9.0")
    system "g++ #{ENV['CXXFLAGS']} -o AtomicParsley -framework Cocoa -DDARWIN_PLATFORM *.mm *.cpp"
    bin.install "AtomicParsley"
  end
end


__END__
diff -Naur a/AtomicParsley-source-0.9.0/AP_NSImage.mm b/AtomicParsley-source-0.9.0/AP_NSImage.mm
--- a/AtomicParsley-source-0.9.0/AP_NSImage.mm	2006-09-02 05:25:32.000000000 -0600
+++ b/AtomicParsley-source-0.9.0/AP_NSImage.mm	2009-09-07 16:44:05.000000000 -0600
@@ -26,8 +26,8 @@
 #include <sys/time.h>
 #include <string.h>
 
-#include "AP_NSImage.h"
 #include "AtomicParsley.h"
+#include "AP_NSImage.h"
 
 bool isJPEG=false;
 bool isPNG=false;
@@ -201,7 +201,7 @@
         
 		NSBitmapImageRep* bitmap = [ [NSBitmapImageRep alloc]
 																	initWithFocusedViewRect: destinationRect ];
-		_NSBitmapImageFileType filetype;
+		NSBitmapImageFileType filetype;
 		NSDictionary *props;
 		
 		if ( (isPNG && !myPicPrefs.allJPEG) || myPicPrefs.allPNG) {
