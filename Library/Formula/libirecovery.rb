require 'formula'

class Libirecovery < Formula
  url 'git://github.com/boxingcow/libirecovery.git'
  homepage 'http://github.com/boxingcow/libirecovery.git'
  version '.1'

  # Patch the Makefile to correct typos in the macosx build target and so that the install target works with dylib.
  def patches
    DATA
  end

  def install
    system "make macosx"
    system "make install"
 end
end

__END__
diff --git a/Makefile b/Makefile
index d75eff9..4313289 100644
--- a/Makefile
+++ b/Makefile
@@ -14,7 +14,7 @@ linux:
 	rm -rf libirecovery.o
 
 macosx:
-	gcc -o libirecovery.dylib -c src/libirecovery.c -dynamiclib
+	gcc -o libirecovery.dylib -c src/libirecovery.c -dynamiclib -I./include
 	gcc -o irecovery src/irecovery.c -I./include -L. -lirecovery -lreadline -lusb-1.0
 	
 windows:
@@ -22,10 +22,9 @@ windows:
 	gcc -o irecovery irecovery.c -I. -lirecovery -lreadline
 	
 install:
-	cp libirecovery.so /usr/local/lib/libirecovery.so
+	cp libirecovery.dylib /usr/local/lib/libirecovery.dylib
 	cp include/libirecovery.h /usr/local/include/libirecovery.h
 	cp irecovery /usr/local/bin/irecovery
-	ldconfig
 	
 uninstall:
 	rm -rf /usr/local/lib/libirecovery.so
