require 'formula'
class Pk2cmd < Formula
  homepage 'http://www.microchip.com/pickit2'
  url 'http://ww1.microchip.com/downloads/en/DeviceDoc/pk2cmdv1.20LinuxMacSource.tar.gz'
  sha1 '19e90a665caef6d993820ce6c7ace5416b656f47'
  version '1.20'

  def compileTarget
  osxVersion = `sw_vers -productVersion`.split(':')[1].to_i
  if(osxVersion == 4)
    'mac104'
  else
    'mac105'
 end
  end

  def install
    system "make", compileTarget
    system "make","PREFIX=#{prefix}","install"
  end

  def patches
    #Adapt to homebrew directory hierarchy
    DATA
  end
end
__END__
diff --git a/Makefile b/Makefile
index 1a23325..8e581cf 100755
--- a/Makefile
+++ b/Makefile
@@ -117,10 +117,11 @@ strnatcmp.o: strnatcmp.c strnatcmp.h stdafx.h
 	$(CC) $(CFLAGS) -x c -o $@  -c $<
 
 install: 
-	mkdir -p /usr/share/pk2
-	cp $(APP) /usr/local/bin
-	chmod u+s /usr/local/bin/$(APP)
-	cp PK2DeviceFile.dat /usr/share/pk2/PK2DeviceFile.dat
+	mkdir -p $(PREFIX)/share/pk2
+	mkdir -p $(PREFIX)/bin
+	cp $(APP) $(PREFIX)/bin
+	chmod u+s $(PREFIX)/bin/$(APP)
+	cp PK2DeviceFile.dat $(PREFIX)/share/pk2/PK2DeviceFile.dat
 
 clean:
 	rm -f *.o
