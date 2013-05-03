require 'formula'

class Sxiv < Formula
  homepage 'https://github.com/muennich/sxiv'
  url 'https://github.com/downloads/muennich/sxiv/sxiv-1.0.tar.gz'
  sha1 'e29e33c38fd2a6c8a2cb3b270776859328aa8e0e'

  head 'https://github.com/muennich/sxiv.git'

  depends_on :x11
  depends_on 'imlib2'
  depends_on 'giflib' => :optional
  depends_on 'libexif' => :optional

  # Makefile uses GNU install
  def patches; DATA; end

  def install
    system "make", "config.h"

    if build.with? "giflib"
      inreplace "config.h", "#define GIF_SUPPORT  0", "#define GIF_SUPPORT  1"
    end

    if build.with? "libexif"
      inreplace "config.h", "#define EXIF_SUPPORT 0", "#define EXIF_SUPPORT 1"
    end

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/sxiv", "-v"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 32c644f..0cd8019 100644
--- a/Makefile
+++ b/Makefile
@@ -52,7 +52,8 @@ dist: clean
 
 install: all
 	@echo "installing executable file to $(DESTDIR)$(PREFIX)/bin"
-	@install -D -m 755 sxiv $(DESTDIR)$(PREFIX)/bin/sxiv
+	@install -d $(DESTDIR)$(PREFIX)/bin
+	@install -m 755 sxiv $(DESTDIR)$(PREFIX)/bin/sxiv
 	@echo "installing manual page to $(DESTDIR)$(MANPREFIX)/man1"
 	@mkdir -p $(DESTDIR)$(MANPREFIX)/man1
 	@sed "s/VERSION/$(VERSION)/g" sxiv.1 > $(DESTDIR)$(MANPREFIX)/man1/sxiv.1
