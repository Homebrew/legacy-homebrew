require 'formula'

class Sfxr < Formula
  url 'http://www.drpetter.se/files/sfxr-sdl-1.1.tar.gz'
  homepage 'http://www.drpetter.se/project_sfxr.html'
  md5 '49670f2d94b04949c77518c9cb3524f7'
  version '1.1'

  depends_on 'sdl'
  depends_on 'gtk+'

  def patches
    # patch to make Makefile install in DESTDIR, not DESTDIR/usr and to skip
    # installation of icon and .desktop file
    DATA
  end

  def install
    # malloc() needs stdlib.h, not malloc.h
    inreplace "sdlkit.h", "malloc.h", "stdlib.h"

    # main.cpp expects files to be in /usr
    inreplace "main.cpp", "/usr/", "/usr/local/"

    system "make DESTDIR=#{prefix} install"
  end

  def test
    system "sfxr"
  end
end

__END__
diff --git i/Makefile w/Makefile
index c940848..b5eae72 100644
--- i/Makefile
+++ w/Makefile
@@ -6,16 +6,10 @@ sfxr: main.cpp tools.h sdlkit.h
 	$(CXX) $< $(CXXFLAGS) $(LDFLAGS) -o $@
 
 install: sfxr
-	mkdir -p $(DESTDIR)/usr/bin
-	mkdir -p $(DESTDIR)/usr/share/sfxr
-	mkdir -p $(DESTDIR)/usr/share/applications
-	mkdir -p $(DESTDIR)/usr/share/icons/hicolor/48x48/apps
-	install -m 755 sfxr $(DESTDIR)/usr/bin
-	install -m 644 -p *.tga *.bmp $(DESTDIR)/usr/share/sfxr
-	install -p -m 644 sfxr.png \
-		$(DESTDIR)/usr/share/icons/hicolor/48x48/apps
-	desktop-file-install --vendor "" \
-		--dir $(DESTDIR)/usr/share/applications sfxr.desktop
+	mkdir -p $(DESTDIR)/bin
+	mkdir -p $(DESTDIR)/share/sfxr
+	install -m 755 sfxr $(DESTDIR)/bin
+	install -m 644 -p *.tga *.bmp $(DESTDIR)/share/sfxr
 
 clean:
 	rm sfxr
